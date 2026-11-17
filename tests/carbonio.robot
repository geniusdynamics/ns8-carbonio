*** Settings ***
Library    SSHLibrary
Library    Collections

*** Variables ***
# Any resolvable-looking name: the schema demands a dot, nothing resolves it.
${TEST_HOST}      mail.ns8-ci.test
${TEST_DOMAIN}    ns8-ci.test
# Generated passwords only: this one exists for the test VM alone
${ADMIN_PASSWORD}    Ci-Test-Passw0rd-2026

*** Test Cases ***
Check if carbonio is installed correctly
    ${output}  ${rc} =    Execute Command    add-module ${IMAGE_URL} 1
    ...    return_rc=True
    Should Be Equal As Integers    ${rc}  0
    &{output} =    Evaluate    ${output}
    Set Suite Variable    ${module_id}    ${output.module_id}

Check that the first configuration requires the admin password
    ${output}  ${rc} =    Execute Command
    ...    api-cli run module/${module_id}/configure-module --data '{"host":"${TEST_HOST}","http2https":true,"lets_encrypt":false,"mail_domain":"${TEST_DOMAIN}"}'
    ...    return_rc=True
    Should Not Be Equal As Integers    ${rc}  0
    Should Contain    ${output}    admin_password_required

Check that the reserved suites are refused
    ${output}  ${rc} =    Execute Command
    ...    api-cli run module/${module_id}/configure-module --data '{"host":"${TEST_HOST}","mail_domain":"${TEST_DOMAIN}","admin_password":"${ADMIN_PASSWORD}","features":{"docs":true}}'
    ...    return_rc=True
    Should Not Be Equal As Integers    ${rc}  0
    Should Contain    ${output}    feature_not_available_yet

Check if carbonio can be configured
    # The first configuration runs the Carbonio setup: several minutes
    ${rc} =    Execute Command
    ...    api-cli run module/${module_id}/configure-module --data '{"host":"${TEST_HOST}","http2https":true,"lets_encrypt":false,"mail_domain":"${TEST_DOMAIN}","admin_password":"${ADMIN_PASSWORD}","antivirus":false}'
    ...    return_rc=True  return_stdout=False  timeout=45 minutes
    Should Be Equal As Integers    ${rc}  0

Check if carbonio configuration reads back without secrets
    ${output}  ${rc} =    Execute Command    api-cli run module/${module_id}/get-configuration --data '{}'
    ...    return_rc=True
    Should Be Equal As Integers    ${rc}  0
    Should Not Contain    ${output}    ${ADMIN_PASSWORD}
    ${config} =    Evaluate    json.loads('''${output}''')    modules=json
    Should Be Equal    ${config}[host]    ${TEST_HOST}
    Should Be Equal    ${config}[mail_domain]    ${TEST_DOMAIN}
    Should Be Equal    ${config}[cluster_role]    standalone
    Should Be True    ${config}[initialized]
    Should Be True    ${config}[admin_password_set]
    Should Not Be True    ${config}[antivirus]

Check that the admin password is not in the journal
    ${output}  ${rc} =    Execute Command    journalctl --since "-2h" | grep -cF '${ADMIN_PASSWORD}'
    ...    return_rc=True
    Should Be Equal As Strings    ${output}    0

Check that the state secrets are private
    ${output} =    Execute Command    stat -c %a /home/${module_id}/.config/state/secrets.env
    Should Be Equal As Strings    ${output}    600

Check the carbonio health
    ${output}  ${rc} =    Execute Command    api-cli run module/${module_id}/get-health --data '{}'
    ...    return_rc=True
    Should Be Equal As Integers    ${rc}  0
    ${health} =    Evaluate    json.loads('''${output}''')    modules=json
    Should Be True    ${health}[healthy]    ${output}
    Dictionary Should Contain Key    ${health}[services]    mta
    Dictionary Should Contain Key    ${health}[services]    mailbox
    Dictionary Should Contain Key    ${health}[services]    proxy

Check the web client through Traefik
    ${output}  ${rc} =    Execute Command
    ...    curl -k -s -o /dev/null -w '\%{http_code}' --resolve ${TEST_HOST}:443:127.0.0.1 https://${TEST_HOST}/static/login/
    ...    return_rc=True
    Should Be Equal As Strings    ${output}    200

Check the administrator login
    ${output}  ${rc} =    Execute Command
    ...    curl -k -s -X POST -H 'Content-Type: application/soap+xml' --resolve ${TEST_HOST}:443:127.0.0.1 https://${TEST_HOST}/service/soap/ --data '<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope"><soap:Body><AuthRequest xmlns="urn:zimbraAccount"><account by="name">admin@${TEST_DOMAIN}</account><password>${ADMIN_PASSWORD}</password></AuthRequest></soap:Body></soap:Envelope>'
    ...    return_rc=True
    Should Contain    ${output}    authToken

Check the SMTP and IMAP ports
    ${output}  ${rc} =    Execute Command
    ...    timeout 10 bash -c 'exec 3<>/dev/tcp/127.0.0.1/25; head -c 3 <&3'
    ...    return_rc=True
    Should Be Equal As Strings    ${output}    220
    ${output}  ${rc} =    Execute Command
    ...    timeout 10 bash -c 'exec 3<>/dev/tcp/127.0.0.1/143; head -c 4 <&3'
    ...    return_rc=True
    Should Be Equal As Strings    ${output}    * OK

Check the local mail delivery
    ${rc} =    Execute Command
    ...    runagent -m ${module_id} podman exec carbonio su - zextras -c 'printf "Subject: ci-delivery\\n\\nhello\\n" | /opt/zextras/common/sbin/sendmail -f admin@${TEST_DOMAIN} admin@${TEST_DOMAIN}'
    ...    return_rc=True  return_stdout=False
    Should Be Equal As Integers    ${rc}  0
    Wait Until Keyword Succeeds    2 minutes    10 seconds    Message is in the admin inbox

Check that the host name cannot change
    ${output}  ${rc} =    Execute Command
    ...    api-cli run module/${module_id}/configure-module --data '{"host":"other.${TEST_DOMAIN}"}'
    ...    return_rc=True
    Should Not Be Equal As Integers    ${rc}  0
    Should Contain    ${output}    host_cannot_change

Check that a configuration without changes keeps carbonio running
    ${before} =    Execute Command    runagent -m ${module_id} podman inspect carbonio --format '{{.State.StartedAt}}'
    ${rc} =    Execute Command
    ...    api-cli run module/${module_id}/configure-module --data '{"host":"${TEST_HOST}","http2https":true,"lets_encrypt":false,"antivirus":false}'
    ...    return_rc=True  return_stdout=False  timeout=15 minutes
    Should Be Equal As Integers    ${rc}  0
    ${after} =    Execute Command    runagent -m ${module_id} podman inspect carbonio --format '{{.State.StartedAt}}'
    Should Be Equal    ${before}    ${after}

Check if carbonio is removed correctly
    ${rc} =    Execute Command    remove-module --no-preserve ${module_id}
    ...    return_rc=True  return_stdout=False
    Should Be Equal As Integers    ${rc}  0

*** Keywords ***
Message is in the admin inbox
    ${output} =    Execute Command
    ...    runagent -m ${module_id} podman exec carbonio su - zextras -c 'zmmailbox -z -m admin@${TEST_DOMAIN} s -t message in:inbox'
    Should Contain    ${output}    ci-delivery
