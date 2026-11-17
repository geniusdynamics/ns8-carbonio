# Seal the join bundle Schema

```txt
http://schema.nethserver.org/carbonio/seal-join-bundle-input.json
```



| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                 |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :----------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [seal-join-bundle-input.json](carbonio/seal-join-bundle-input.json "open original schema") |

## Seal the join bundle Type

`object` ([Seal the join bundle](seal-join-bundle-input.md))

# Seal the join bundle Properties

| Property                  | Type     | Required | Nullable       | Defined by                                                                                                                                                         |
| :------------------------ | :------- | :------- | :------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [public_key](#public_key) | `string` | Required | cannot be null | [Seal the join bundle](seal-join-bundle-input-properties-public_key.md "http://schema.nethserver.org/carbonio/seal-join-bundle-input.json#/properties/public_key") |
| [module_id](#module_id)   | `string` | Required | cannot be null | [Seal the join bundle](seal-join-bundle-input-properties-module_id.md "http://schema.nethserver.org/carbonio/seal-join-bundle-input.json#/properties/module_id")   |
| [fqdn](#fqdn)             | `string` | Optional | cannot be null | [Seal the join bundle](seal-join-bundle-input-properties-fqdn.md "http://schema.nethserver.org/carbonio/seal-join-bundle-input.json#/properties/fqdn")             |

## public_key

Ephemeral X25519 public key of the caller, base64

`public_key`

* is required

* Type: `string`

* cannot be null

* defined in: [Seal the join bundle](seal-join-bundle-input-properties-public_key.md "http://schema.nethserver.org/carbonio/seal-join-bundle-input.json#/properties/public_key")

### public_key Type

`string`

### public_key Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^[A-Za-z0-9+/]{43}=$
```

[try pattern](https://regexr.com/?expression=%5E%5BA-Za-z0-9%2B%2F%5D%7B43%7D%3D%24 "try regular expression with regexr.com")

## module_id



`module_id`

* is required

* Type: `string`

* cannot be null

* defined in: [Seal the join bundle](seal-join-bundle-input-properties-module_id.md "http://schema.nethserver.org/carbonio/seal-join-bundle-input.json#/properties/module_id")

### module_id Type

`string`

### module_id Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^[a-z][a-z0-9-]*[0-9]+$
```

[try pattern](https://regexr.com/?expression=%5E%5Ba-z%5D%5Ba-z0-9-%5D*%5B0-9%5D%2B%24 "try regular expression with regexr.com")

## fqdn



`fqdn`

* is optional

* Type: `string`

* cannot be null

* defined in: [Seal the join bundle](seal-join-bundle-input-properties-fqdn.md "http://schema.nethserver.org/carbonio/seal-join-bundle-input.json#/properties/fqdn")

### fqdn Type

`string`
