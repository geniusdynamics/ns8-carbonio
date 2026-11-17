# Get Carbonio configuration Schema

```txt
http://schema.nethserver.org/carbonio/get-configuration-output.json
```



| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                     |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :--------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Allowed               | none                | [get-configuration-output.json](carbonio/get-configuration-output.json "open original schema") |

## Get Carbonio configuration Type

`object` ([Get Carbonio configuration](get-configuration-output.md))

# Get Carbonio configuration Properties

| Property                                  | Type      | Required | Nullable       | Defined by                                                                                                                                                                                   |
| :---------------------------------------- | :-------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [host](#host)                             | `string`  | Required | cannot be null | [Get Carbonio configuration](get-configuration-output-properties-host.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/host")                             |
| [http2https](#http2https)                 | `boolean` | Optional | cannot be null | [Get Carbonio configuration](get-configuration-output-properties-http2https.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/http2https")                 |
| [lets_encrypt](#lets_encrypt)             | `boolean` | Optional | cannot be null | [Get Carbonio configuration](get-configuration-output-properties-lets_encrypt.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/lets_encrypt")             |
| [cluster_role](#cluster_role)             | `string`  | Required | cannot be null | [Get Carbonio configuration](get-configuration-output-properties-cluster_role.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/cluster_role")             |
| [join](#join)                             | `string`  | Optional | cannot be null | [Get Carbonio configuration](get-configuration-output-properties-join.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/join")                             |
| [accept_join](#accept_join)               | `boolean` | Optional | cannot be null | [Get Carbonio configuration](get-configuration-output-properties-accept_join.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/accept_join")               |
| [mail_domain](#mail_domain)               | `string`  | Optional | cannot be null | [Get Carbonio configuration](get-configuration-output-properties-mail_domain.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/mail_domain")               |
| [admin_user](#admin_user)                 | `string`  | Optional | cannot be null | [Get Carbonio configuration](get-configuration-output-properties-admin_user.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/admin_user")                 |
| [admin_password_set](#admin_password_set) | `boolean` | Required | cannot be null | [Get Carbonio configuration](get-configuration-output-properties-admin_password_set.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/admin_password_set") |
| [admin_host](#admin_host)                 | `string`  | Optional | cannot be null | [Get Carbonio configuration](get-configuration-output-properties-admin_host.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/admin_host")                 |
| [antivirus](#antivirus)                   | `boolean` | Optional | cannot be null | [Get Carbonio configuration](get-configuration-output-properties-antivirus.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/antivirus")                   |
| [mailbox_heap_mb](#mailbox_heap_mb)       | `integer` | Optional | cannot be null | [Get Carbonio configuration](get-configuration-output-properties-mailbox_heap_mb.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/mailbox_heap_mb")       |
| [timezone](#timezone)                     | `string`  | Optional | cannot be null | [Get Carbonio configuration](get-configuration-output-properties-timezone.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/timezone")                     |
| [features](#features)                     | `object`  | Optional | cannot be null | [Get Carbonio configuration](get-configuration-output-properties-features.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/features")                     |
| [initialized](#initialized)               | `boolean` | Required | cannot be null | [Get Carbonio configuration](get-configuration-output-properties-initialized.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/initialized")               |
| [release](#release)                       | `string`  | Optional | cannot be null | [Get Carbonio configuration](get-configuration-output-properties-release.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/release")                       |
| [ldap_secrets_set](#ldap_secrets_set)     | `boolean` | Optional | cannot be null | [Get Carbonio configuration](get-configuration-output-properties-ldap_secrets_set.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/ldap_secrets_set")     |
| [available_masters](#available_masters)   | `array`   | Required | cannot be null | [Get Carbonio configuration](get-configuration-output-properties-available_masters.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/available_masters")   |

## host



`host`

* is required

* Type: `string`

* cannot be null

* defined in: [Get Carbonio configuration](get-configuration-output-properties-host.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/host")

### host Type

`string`

## http2https



`http2https`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [Get Carbonio configuration](get-configuration-output-properties-http2https.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/http2https")

### http2https Type

`boolean`

## lets_encrypt



`lets_encrypt`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [Get Carbonio configuration](get-configuration-output-properties-lets_encrypt.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/lets_encrypt")

### lets_encrypt Type

`boolean`

## cluster_role



`cluster_role`

* is required

* Type: `string`

* cannot be null

* defined in: [Get Carbonio configuration](get-configuration-output-properties-cluster_role.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/cluster_role")

### cluster_role Type

`string`

### cluster_role Constraints

**enum**: the value of this property must be equal to one of the following values:

| Value          | Explanation |    |    |
| :------------- | :---------- | :- | :- |
| `"standalone"` |             |
| `"master"`     |             |
| `"worker"`     |             |

## join



`join`

* is optional

* Type: `string`

* cannot be null

* defined in: [Get Carbonio configuration](get-configuration-output-properties-join.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/join")

### join Type

`string`

## accept_join



`accept_join`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [Get Carbonio configuration](get-configuration-output-properties-accept_join.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/accept_join")

### accept_join Type

`boolean`

## mail_domain



`mail_domain`

* is optional

* Type: `string`

* cannot be null

* defined in: [Get Carbonio configuration](get-configuration-output-properties-mail_domain.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/mail_domain")

### mail_domain Type

`string`

## admin_user



`admin_user`

* is optional

* Type: `string`

* cannot be null

* defined in: [Get Carbonio configuration](get-configuration-output-properties-admin_user.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/admin_user")

### admin_user Type

`string`

## admin_password_set



`admin_password_set`

* is required

* Type: `boolean`

* cannot be null

* defined in: [Get Carbonio configuration](get-configuration-output-properties-admin_password_set.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/admin_password_set")

### admin_password_set Type

`boolean`

## admin_host



`admin_host`

* is optional

* Type: `string`

* cannot be null

* defined in: [Get Carbonio configuration](get-configuration-output-properties-admin_host.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/admin_host")

### admin_host Type

`string`

## antivirus



`antivirus`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [Get Carbonio configuration](get-configuration-output-properties-antivirus.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/antivirus")

### antivirus Type

`boolean`

## mailbox_heap_mb



`mailbox_heap_mb`

* is optional

* Type: `integer`

* cannot be null

* defined in: [Get Carbonio configuration](get-configuration-output-properties-mailbox_heap_mb.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/mailbox_heap_mb")

### mailbox_heap_mb Type

`integer`

## timezone



`timezone`

* is optional

* Type: `string`

* cannot be null

* defined in: [Get Carbonio configuration](get-configuration-output-properties-timezone.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/timezone")

### timezone Type

`string`

## features



`features`

* is optional

* Type: `object` ([Details](get-configuration-output-properties-features.md))

* cannot be null

* defined in: [Get Carbonio configuration](get-configuration-output-properties-features.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/features")

### features Type

`object` ([Details](get-configuration-output-properties-features.md))

## initialized



`initialized`

* is required

* Type: `boolean`

* cannot be null

* defined in: [Get Carbonio configuration](get-configuration-output-properties-initialized.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/initialized")

### initialized Type

`boolean`

## release



`release`

* is optional

* Type: `string`

* cannot be null

* defined in: [Get Carbonio configuration](get-configuration-output-properties-release.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/release")

### release Type

`string`

## ldap_secrets_set



`ldap_secrets_set`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [Get Carbonio configuration](get-configuration-output-properties-ldap_secrets_set.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/ldap_secrets_set")

### ldap_secrets_set Type

`boolean`

## available_masters



`available_masters`

* is required

* Type: `object[]` ([Details](get-configuration-output-properties-available_masters-items.md))

* cannot be null

* defined in: [Get Carbonio configuration](get-configuration-output-properties-available_masters.md "http://schema.nethserver.org/carbonio/get-configuration-output.json#/properties/available_masters")

### available_masters Type

`object[]` ([Details](get-configuration-output-properties-available_masters-items.md))
