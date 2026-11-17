# ns8-carbonio

[Carbonio Community Edition](https://www.zextras.com/carbonio-community-edition/)
mail and collaboration server for [NethServer 8](https://github.com/NethServer/ns8-core).
It provides webmail, calendars, contacts, the Admin Panel, and IMAP, POP3 and SMTP.

One instance gives one complete mail server, which suits a single business.
Several instances on different nodes form a multi-server installation for larger
sites. For that case, [ns8-carbonio-proxy](https://github.com/geniusdynamics/ns8-carbonio-proxy)
adds an extra entry point to the installation.

> **Unofficial.** Genius Dynamics builds this module from the public Carbonio CE
> packages. Zextras does not endorse it. "Carbonio" and "Zextras" are trademarks
> of Zextras.

## Contents

- [Quick start: one server](#quick-start-one-server)
- [Multi-server installation](#multi-server-installation)
- [How it works](#how-it-works)
- [Ports](#ports)
- [Backup and restore](#backup-and-restore)
- [Updates and upgrades](#updates-and-upgrades)
- [Known limits](#known-limits)
- [Not in this release](#not-in-this-release)
- [Licences](#licences)
- [Debug](#debug)

## Quick start: one server

Requirements:

- An NS8 node with about **4 GiB of free RAM**. ClamAV needs another 1.3 GiB if
  you turn on the antivirus.
- The mail ports of the node free. No other mail application (ns8-mail,
  mailcow, and so on) can run on the same node.
- DNS records:
  - An A record for the host name, for example `mail.example.org`, pointing to
    the node.
  - An MX record for the mail domain, pointing to the host name.
  - A PTR record for the node address, matching the host name.

Steps:

1. Install **Carbonio CE** from the Software Center, or from the command line:

       add-module ghcr.io/geniusdynamics/carbonio:latest 1

2. Open the application, then *Settings*:
   1. Keep **Single server**.
   2. Set the host name, the first mail domain and the administrator password.
   3. Turn on Let's Encrypt when the DNS is ready.
3. Save. The first configuration installs Carbonio and takes **5 to 10 minutes**;
   the progress bar follows it.
4. Log in:
   - Webmail: `https://mail.example.org`, as `admin@example.org` with the
     password you set.
   - Admin Panel: give it its own host name in *Settings*, *Advanced*, for
     example `mailadmin.example.org`. Without one, the Admin Panel is reachable
     only from the node.

The same configuration from the command line:

```bash
api-cli run module/carbonio1/configure-module --data - <<'EOF'
{
  "host": "mail.example.org",
  "mail_domain": "example.org",
  "admin_password": "Use-a-str0ng-password",
  "lets_encrypt": true,
  "http2https": true,
  "antivirus": true
}
EOF
```

### What the configuration does

- **Web traffic.** Traefik keeps ports 80 and 443 of the node and forwards the
  web client to Carbonio. With Let's Encrypt on, the same certificate is also
  installed into Carbonio for SMTP, IMAP and POP3, and renewals follow
  automatically.
- **Mail ports.** Carbonio publishes 25, 465, 587, 110, 143, 993 and 995 on the
  node, and opens them in the firewall.
- **Validation.** Configuration is refused when:
  - another mail application is installed on the node,
  - a mail port is in use, or
  - the host name is already routed by Traefik.
- **Changes after the first setup.** These can change later: the antivirus,
  memory, time zone, Admin Panel host name, Let's Encrypt and the administrator
  password. The host name, the first mail domain and the administrator account
  name are written into the directory and cannot change.
- **Restarts.** Saving restarts Carbonio only when a setting of its container
  changed.

The *Status* page shows the state of every Carbonio service. From the command
line, use the `get-health` action:

```bash
api-cli run module/carbonio1/get-health
```

## Multi-server installation

**Experimental.** Every step below was tested with containers on one host (see
[How it works](#how-it-works)). The CI covers the single-server case only, and
real multi-node NS8 clusters still need validation.

Carbonio servers coordinate through the directory (LDAP) of the main server, as
in a classic Carbonio multi-server installation:

- **Main server** (`master`): a complete server, the same as a single server,
  that other servers can join. It keeps the directory, the mail transfer
  (inbound and outbound SMTP) and the first mailboxes.
- **Additional mailbox server** (`worker`): more mailboxes on another node. It
  uses the main server's directory and mail transfer.
- **Edge proxy** ([ns8-carbonio-proxy](https://github.com/geniusdynamics/ns8-carbonio-proxy)):
  another web, IMAP and POP3 entry point. It routes every user to the server
  that holds their mailbox.

Every server runs on its own node. The servers reach each other on the cluster
WireGuard network only.

1. **Main server.** On the first node, configure the instance as *Main server of
   a multi-server installation*, with *Accept new servers* on:

   ```bash
   api-cli run module/carbonio1/configure-module --data '{"host":"mail.example.org","mail_domain":"example.org","admin_password":"Use-a-str0ng-password","cluster_role":"master"}'
   ```

   Turning a single server into a main server later also works. The other
   direction works too, but only while no other server has joined.

2. **Additional mailbox server.**
   1. Install Carbonio CE on another node.
   2. Choose *Additional mailbox server*.
   3. Pick the main server from the list. The list shows the main servers found
      in the cluster that accept new servers and run the same Carbonio release.

   ```bash
   api-cli run module/carbonio2/configure-module --data '{"host":"mbx2.example.org","cluster_role":"worker","join":"carbonio1"}'
   ```

   Before the new server starts, it receives the passwords of the directory
   service accounts from the main server (see [Secrets](#secrets)). The two
   servers then add each other's host names to their containers, resolved to
   their WireGuard addresses.

3. **Mailboxes on the new server.** In the Admin Panel, create accounts on the
   new server, or move mailboxes to it. Webmail, IMAP and POP3 on the main
   server, and on any edge proxy, route each user to their mailbox server.
   Inbound mail arrives on the main server and is delivered over LMTP to the
   right server.

### Redis key contract

Every instance publishes a non-secret service record:

```
module/<module_id>/srv/tcp/carbonio        (hash)
  host         WireGuard address of the node
  fqdn         Carbonio server name
  role         standalone | master | worker
  master       module id of the main server (itself for a main server)
  node         node id
  release      Carbonio release, for example 26.9.2
  accept_join  "1" when a main server accepts new servers
  public_host  web host name
  mail_domain  first mail domain (main servers)
```

ns8-carbonio-proxy publishes the same fields under `.../srv/tcp/carbonio-proxy`.

Each publish fires the `carbonio-server-changed` event. On that event, and on
`module-removed`, every instance rewrites `state/runtime/hosts`. The container
applies the new list within 30 seconds, without a restart.

### Secrets

All NS8 modules can read Redis, and NS8 keeps task input and output in Redis
for hours. So the passwords of the directory service accounts (zimbra, postfix,
amavis, nginx, replication) never go there in clear. A joining server gets them
as a sealed bundle:

1. The joining server creates an ephemeral X25519 key pair. Its private key only
   ever exists in memory.
2. It calls `seal-join-bundle` on the main server, sending the public key.
3. The main server encrypts the bundle for that key: ECDH, then HKDF-SHA256,
   then AES-256-GCM. The task output kept in Redis is useless to anyone else.
4. The joining server decrypts the bundle and writes it to its own
   `state/secrets.env`, with mode 0600.

Who can call `seal-join-bundle`:

- **Modules holding the `carbonio-peer` role on the main server.** This means
  the ns8-carbonio and ns8-carbonio-proxy instances, through their image label
  `carbonio@any:carbonio-peer`, which the cluster grants when they are
  installed.
- **Cluster administrators.**

Ways to restrict it:

- The action is not a `get-`/`list-` action, so the reader role cannot call it.
- A main server answers only while *Accept new servers* is on. Turn it off once
  every server has joined.

Other secrets:

- **The administrator password.** It is used once by the first setup, and then
  removed from `state/secrets.env`.
- **Password changes.** They reach Carbonio on the standard input of `zmprov`,
  never on a command line or in a log.
- **`get-configuration`.** It reports only `admin_password_set` and
  `ldap_secrets_set`.

## How it works

### Image

Zextras publishes no supported container images for Carbonio CE. The images on
Docker Hub are undocumented, stopped updating in January 2026, and have no
upgrade path. This repository therefore builds its own runtime image,
`ghcr.io/geniusdynamics/carbonio-server`, from the public packages at
`repo.zextras.io`. See [server/Containerfile](server/Containerfile).

- **Base: Ubuntu 22.04.** It is the newest release where Carbonio still ships
  the `zmcontrol` service manager. On 24.04 Carbonio is systemd-only.
- **Package versions are pinned.** Renovate opens one pull request per Carbonio
  release, through a `deb` custom manager in [renovate.json](renovate.json).
  These pull requests are never automerged.
- **No systemd, no privileges.** The container runs with Podman's default
  rootless capabilities. [carbonio-run](server/rootfs/usr/local/sbin/carbonio-run)
  is the entrypoint:
  - **First start:** runs the Carbonio setup with the generated passwords. It
    never uses the `password` defaults of the upstream images.
  - **Image changed:** upgrades the data or refuses a downgrade (see
    [Updates and upgrades](#updates-and-upgrades)).
  - **Every start:** applies the runtime settings, starts the services with
    `zmcontrol`, sends syslog to the journal and runs cron.
  - **SIGTERM:** stops the services cleanly.
- **One image for every role.** The role picks which Carbonio services the
  setup enables.
- **pending-setups is replaced.** It is the only proprietary Carbonio package.
  It registers services in the Carbonio Mesh, which this release does not run,
  so a no-op stand-in takes its place.

### Units and volumes

- **One systemd unit, `carbonio.service`, runs one container.**
- **`bin/carbonio-prepare` (ExecStartPre)** writes:
  - the container settings (`state/runtime/container.env`, no secrets),
  - the published ports (`state/runtime/runtime.env`),
  - the cluster host names (`state/runtime/hosts`).
- **Volumes** are mounted under `/opt/zextras/`:

  | Volume | Content |
  |---|---|
  | `carbonio-conf` | Configuration, `localconfig.xml`, the module's markers in `.ns8/` |
  | `carbonio-data` | LDAP, MTA queue, amavis, ClamAV |
  | `carbonio-db` | MariaDB of the mailboxes |
  | `carbonio-ssl` | Certificates |
  | `carbonio-log` | Logs |
  | `carbonio-store` | Messages |
  | `carbonio-index` | Search index |
  | `carbonio-redolog` | Redo log |

  `carbonio-store` and `carbonio-index` can go on an additional disk.

## Ports

| Port | Bound on | Who |
|---|---|---|
| 25, 465, 587, 110, 143, 993, 995 | every node address | single and main server |
| web client (443 in the container) | 127.0.0.1, `TCP_PORTS[0]`, behind Traefik | every role |
| Admin Panel (6071 in the container) | 127.0.0.1, `TCP_PORTS[1]`, behind Traefik with its own host name | every role |
| 389, 7025, 7071-7073, 7110, 7143, 7993, 7995, 8080, 8443 | node WireGuard address | main server |
| 7025, 7071-7073, 7110, 7143, 7993, 7995, 8080, 8443 | node WireGuard address | additional mailbox server |

There is one instance per node (`org.nethserver.max-per-node=1`), because the
mail ports and the cluster ports are fixed.

## Backup and restore

- **Before each backup**, `module-dump-state` takes consistent dumps of the
  directory (`state/dump/ldap.ldif`) and of the mailbox database
  (`state/dump/mariadb.sql.gz`).
- **The backup** holds these dumps, together with the volumes and
  `state/secrets.env`.
- **On restore**, the volumes come back first. Before the services start, the
  first start then reloads the directory and the database from the dumps. The
  volume copies were taken while Carbonio ran, so the dumps are the consistent
  copy. Let's Encrypt is not requested during a restore: turn it on again once
  the DNS points to the node.
- **Restore a whole installation in order:** main server first, then the
  additional servers.

## Updates and upgrades

- **Update procedure.** `update-module.d/10check_release` runs first, while the
  previous release still runs. It compares the Carbonio packages of the new
  image with the ones that last ran on the data:
  - **Newer:** it takes fresh dumps. `20restart` then starts the new release,
    which upgrades the data:
    - Package files under `conf`, `data` and `db` are merged the way dpkg
      handles configuration files. A file you changed is kept, and the new
      version is saved next to it as `.ns8-dist`.
    - `localconfig.xml` is never replaced.
    - The LDAP schema goes through the same steps as the package upgrade
      (`zmldapschema`, `zmldapupdateldif`, `ldapattributeupdate`).
  - **Older (a downgrade):** **refused**. The running release is kept and the
    update reports the error. If the node reboots, the container refuses to
    start (exit code 3, not retried). Install the previous module version again.
- **Unknown database schema.** If the mailbox database schema of the data does
  not match the release, the container refuses to start with a clear message.
  Carbonio's database migrations are manual.
- **Order for a multi-server installation.** Update the main server first, then
  the additional servers. A server joins only a main server of the same release.

## Known limits

- **LMTP without TLS.** The Carbonio mailbox fails the STARTTLS handshake on
  LMTP: its default SSL context has no key. Mail delivery would stay deferred,
  so LMTP runs in clear: inside the container, or on the cluster WireGuard
  network between servers.
- **Client addresses on the web.** Carbonio sees the web clients through
  Traefik. The HTTP throttling therefore trusts the private networks.
- **Ubuntu 22.04** standard support ends in April 2027. When Zextras drops 22.04
  packages, the image must move to systemd inside the container.
- **The Zextras package signing key** expires on 2027-01-11. The build fetches
  the current key from keyserver.ubuntu.com and checks its fingerprint.

## Not in this release

These are planned as an optional add-on, off by default. Each needs several GiB
of RAM:

- **Files, Docs, Preview, Chats and video calls.** These need PostgreSQL, the
  Carbonio Mesh (Consul with Envoy sidecars) and systemd units. The *Settings*
  page shows them as *coming soon*, and `configure-module` refuses them.
- **Login with an NS8 user domain** (OpenLDAP or Samba), through the Carbonio
  external authentication of a mail domain.
- **Metrics.** The Carbonio images include Prometheus exporters, but they are
  not wired yet.

## Licences

- **The module** is under GPL-3.0-or-later.
- **The runtime image** contains the unmodified Carbonio CE packages:
  - GPL-2.0-only and AGPL-3.0-only for the server and the web UIs,
  - BSD, Apache-2.0 and MPL-2.0 for other components,
  - plus Ubuntu packages.

  Their licence texts are in `/usr/share/doc` in the image. Their source code is
  at https://github.com/zextras.
- **No proprietary package is included.** `pending-setups` is replaced by
  [a no-op stand-in](server/pending-setups-shim).

## Debug

```bash
runagent -m carbonio1 systemctl --user status carbonio
journalctl _UID=$(id -u carbonio1) -t carbonio -f
runagent -m carbonio1 podman exec carbonio carbonio-status
runagent -m carbonio1 podman exec -it carbonio su - zextras    # zmcontrol status, zmprov ...
```

## Testing

```
./test-module.sh <NODE_ADDR> ghcr.io/geniusdynamics/carbonio:latest
```

The QEMU workflow runs `tests/` on a fresh NS8 node for every push, after the
images are published.
