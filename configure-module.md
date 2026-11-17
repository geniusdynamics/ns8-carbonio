# Configure Carbonio Schema

```txt
http://schema.nethserver.org/carbonio/configure-module.json
```

Configure a Carbonio CE server

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                     |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [configure-module.json](carbonio/configure-module.json "open original schema") |

## Configure Carbonio Type

`object` ([Configure Carbonio](configure-module.md))

## Configure Carbonio Examples

```json
{
  "host": "mail.example.org",
  "lets_encrypt": true,
  "http2https": true,
  "mail_domain": "example.org",
  "admin_password": "a-strong-password"
}
```

```json
{
  "host": "mail2.example.org",
  "lets_encrypt": false,
  "http2https": true,
  "cluster_role": "worker",
  "join": "carbonio1"
}
```

# Configure Carbonio Properties

| Property                            | Type      | Required | Nullable       | Defined by                                                                                                                                                     |
| :---------------------------------- | :-------- | :------- | :------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [host](#host)                       | `string`  | Required | cannot be null | [Configure Carbonio](configure-module-properties-host.md "http://schema.nethserver.org/carbonio/configure-module.json#/properties/host")                       |
| [lets_encrypt](#lets_encrypt)       | `boolean` | Optional | cannot be null | [Configure Carbonio](configure-module-properties-lets_encrypt.md "http://schema.nethserver.org/carbonio/configure-module.json#/properties/lets_encrypt")       |
| [http2https](#http2https)           | `boolean` | Optional | cannot be null | [Configure Carbonio](configure-module-properties-http2https.md "http://schema.nethserver.org/carbonio/configure-module.json#/properties/http2https")           |
| [cluster_role](#cluster_role)       | `string`  | Optional | cannot be null | [Configure Carbonio](configure-module-properties-cluster_role.md "http://schema.nethserver.org/carbonio/configure-module.json#/properties/cluster_role")       |
| [join](#join)                       | `string`  | Optional | cannot be null | [Configure Carbonio](configure-module-properties-join.md "http://schema.nethserver.org/carbonio/configure-module.json#/properties/join")                       |
| [accept_join](#accept_join)         | `boolean` | Optional | cannot be null | [Configure Carbonio](configure-module-properties-accept_join.md "http://schema.nethserver.org/carbonio/configure-module.json#/properties/accept_join")         |
| [mail_domain](#mail_domain)         | `string`  | Optional | cannot be null | [Configure Carbonio](configure-module-properties-mail_domain.md "http://schema.nethserver.org/carbonio/configure-module.json#/properties/mail_domain")         |
| [admin_user](#admin_user)           | `string`  | Optional | cannot be null | [Configure Carbonio](configure-module-properties-admin_user.md "http://schema.nethserver.org/carbonio/configure-module.json#/properties/admin_user")           |
| [admin_password](#admin_password)   | `string`  | Optional | cannot be null | [Configure Carbonio](configure-module-properties-admin_password.md "http://schema.nethserver.org/carbonio/configure-module.json#/properties/admin_password")   |
| [admin_host](#admin_host)           | `string`  | Optional | cannot be null | [Configure Carbonio](configure-module-properties-admin_host.md "http://schema.nethserver.org/carbonio/configure-module.json#/properties/admin_host")           |
| [antivirus](#antivirus)             | `boolean` | Optional | cannot be null | [Configure Carbonio](configure-module-properties-antivirus.md "http://schema.nethserver.org/carbonio/configure-module.json#/properties/antivirus")             |
| [mailbox_heap_mb](#mailbox_heap_mb) | `integer` | Optional | cannot be null | [Configure Carbonio](configure-module-properties-mailbox_heap_mb.md "http://schema.nethserver.org/carbonio/configure-module.json#/properties/mailbox_heap_mb") |
| [timezone](#timezone)               | `string`  | Optional | cannot be null | [Configure Carbonio](configure-module-properties-timezone.md "http://schema.nethserver.org/carbonio/configure-module.json#/properties/timezone")               |
| [features](#features)               | `object`  | Optional | cannot be null | [Configure Carbonio](configure-module-properties-features.md "http://schema.nethserver.org/carbonio/configure-module.json#/properties/features")               |

## host

Server host name (FQDN): web client host, SMTP banner and Carbonio server name. It cannot change after the first configuration.

`host`

* is required

* Type: `string`

* cannot be null

* defined in: [Configure Carbonio](configure-module-properties-host.md "http://schema.nethserver.org/carbonio/configure-module.json#/properties/host")

### host Type

`string`

### host Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
\.
```

[try pattern](https://regexr.com/?expression=%5C. "try regular expression with regexr.com")

**hostname**: the string must be a hostname, according to [RFC 1123, section 2.1](https://tools.ietf.org/html/rfc1123 "check the specification")

## lets_encrypt

Request a Let's Encrypt certificate for the host name, also used by SMTP, IMAP and POP3

`lets_encrypt`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [Configure Carbonio](configure-module-properties-lets_encrypt.md "http://schema.nethserver.org/carbonio/configure-module.json#/properties/lets_encrypt")

### lets_encrypt Type

`boolean`

## http2https

Redirect HTTP to HTTPS

`http2https`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [Configure Carbonio](configure-module-properties-http2https.md "http://schema.nethserver.org/carbonio/configure-module.json#/properties/http2https")

### http2https Type

`boolean`

## cluster_role

standalone (default): one complete server. master: a complete server that other servers can join. worker: an additional mailbox server that joins a master.

`cluster_role`

* is optional

* Type: `string`

* cannot be null

* defined in: [Configure Carbonio](configure-module-properties-cluster_role.md "http://schema.nethserver.org/carbonio/configure-module.json#/properties/cluster_role")

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

Module id of the master to join (worker role)

`join`

* is optional

* Type: `string`

* cannot be null

* defined in: [Configure Carbonio](configure-module-properties-join.md "http://schema.nethserver.org/carbonio/configure-module.json#/properties/join")

### join Type

`string`

### join Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^([a-z][a-z0-9-]*[0-9]+)?$
```

[try pattern](https://regexr.com/?expression=%5E\(%5Ba-z%5D%5Ba-z0-9-%5D*%5B0-9%5D%2B\)%3F%24 "try regular expression with regexr.com")

## accept_join

A master accepts new servers (default true)

`accept_join`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [Configure Carbonio](configure-module-properties-accept_join.md "http://schema.nethserver.org/carbonio/configure-module.json#/properties/accept_join")

### accept_join Type

`boolean`

## mail_domain

First mail domain, created with the administrator account (standalone and master, first configuration only)

`mail_domain`

* is optional

* Type: `string`

* cannot be null

* defined in: [Configure Carbonio](configure-module-properties-mail_domain.md "http://schema.nethserver.org/carbonio/configure-module.json#/properties/mail_domain")

### mail_domain Type

`string`

### mail_domain Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
\.
```

[try pattern](https://regexr.com/?expression=%5C. "try regular expression with regexr.com")

**hostname**: the string must be a hostname, according to [RFC 1123, section 2.1](https://tools.ietf.org/html/rfc1123 "check the specification")

## admin_user

Local part of the administrator account, first configuration only (default admin)

`admin_user`

* is optional

* Type: `string`

* cannot be null

* defined in: [Configure Carbonio](configure-module-properties-admin_user.md "http://schema.nethserver.org/carbonio/configure-module.json#/properties/admin_user")

### admin_user Type

`string`

### admin_user Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^[a-z0-9][a-z0-9._-]{0,63}$
```

[try pattern](https://regexr.com/?expression=%5E%5Ba-z0-9%5D%5Ba-z0-9._-%5D%7B0%2C63%7D%24 "try regular expression with regexr.com")

## admin_password

Password of the administrator account: required by the first configuration of a standalone or master server, then optional to change it. Never returned.

`admin_password`

* is optional

* Type: `string`

* cannot be null

* defined in: [Configure Carbonio](configure-module-properties-admin_password.md "http://schema.nethserver.org/carbonio/configure-module.json#/properties/admin_password")

### admin_password Type

`string`

### admin_password Constraints

**maximum length**: the maximum number of characters for this string is: `128`

**minimum length**: the minimum number of characters for this string is: `10`

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^[A-Za-z0-9!#%&()*+,./:;<=>?@^_{|}~\[\]-]+$
```

[try pattern](https://regexr.com/?expression=%5E%5BA-Za-z0-9!%23%25%26\(\)*%2B%2C.%2F%3A%3B%3C%3D%3E%3F%40%5E_%7B%7C%7D~%5C%5B%5C%5D-%5D%2B%24 "try regular expression with regexr.com")

## admin_host

Optional host name (FQDN) that Traefik routes to the Carbonio Admin Panel; empty: no route

`admin_host`

* is optional

* Type: `string`

* cannot be null

* defined in: [Configure Carbonio](configure-module-properties-admin_host.md "http://schema.nethserver.org/carbonio/configure-module.json#/properties/admin_host")

### admin_host Type

`string`

### admin_host Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^([a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,}$|^$
```

[try pattern](https://regexr.com/?expression=%5E\(%5Ba-zA-Z0-9%5D\(%5Ba-zA-Z0-9-%5D%7B0%2C61%7D%5Ba-zA-Z0-9%5D\)%3F%5C.\)%2B%5Ba-zA-Z%5D%7B2%2C%7D%24%7C%5E%24 "try regular expression with regexr.com")

## antivirus

ClamAV antivirus scan of the mail (default true). It needs about 1.3 GiB of RAM.

`antivirus`

* is optional

* Type: `boolean`

* cannot be null

* defined in: [Configure Carbonio](configure-module-properties-antivirus.md "http://schema.nethserver.org/carbonio/configure-module.json#/properties/antivirus")

### antivirus Type

`boolean`

## mailbox_heap_mb

Java heap of the mailbox service, in MiB (default 1536)

`mailbox_heap_mb`

* is optional

* Type: `integer`

* cannot be null

* defined in: [Configure Carbonio](configure-module-properties-mailbox_heap_mb.md "http://schema.nethserver.org/carbonio/configure-module.json#/properties/mailbox_heap_mb")

### mailbox_heap_mb Type

`integer`

### mailbox_heap_mb Constraints

**maximum**: the value of this number must smaller than or equal to: `65536`

**minimum**: the value of this number must greater than or equal to: `512`

## timezone

Default time zone of new accounts (default: the node time zone)

`timezone`

* is optional

* Type: `string`

* cannot be null

* defined in: [Configure Carbonio](configure-module-properties-timezone.md "http://schema.nethserver.org/carbonio/configure-module.json#/properties/timezone")

### timezone Type

`string`

### timezone Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^[A-Za-z0-9_+/-]+$
```

[try pattern](https://regexr.com/?expression=%5E%5BA-Za-z0-9_%2B%2F-%5D%2B%24 "try regular expression with regexr.com")

## features

Optional suites, reserved for a later release: they must be false

`features`

* is optional

* Type: `object` ([Details](configure-module-properties-features.md))

* cannot be null

* defined in: [Configure Carbonio](configure-module-properties-features.md "http://schema.nethserver.org/carbonio/configure-module.json#/properties/features")

### features Type

`object` ([Details](configure-module-properties-features.md))
