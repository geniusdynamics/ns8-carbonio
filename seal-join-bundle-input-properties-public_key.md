# Untitled string in Seal the join bundle Schema

```txt
http://schema.nethserver.org/carbonio/seal-join-bundle-input.json#/properties/public_key
```

Ephemeral X25519 public key of the caller, base64

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                   |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [seal-join-bundle-input.json\*](carbonio/seal-join-bundle-input.json "open original schema") |

## public_key Type

`string`

## public_key Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^[A-Za-z0-9+/]{43}=$
```

[try pattern](https://regexr.com/?expression=%5E%5BA-Za-z0-9%2B%2F%5D%7B43%7D%3D%24 "try regular expression with regexr.com")
