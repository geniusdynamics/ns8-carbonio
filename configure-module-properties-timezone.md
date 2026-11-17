# Untitled string in Configure Carbonio Schema

```txt
http://schema.nethserver.org/carbonio/configure-module.json#/properties/timezone
```

Default time zone of new accounts (default: the node time zone)

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                       |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [configure-module.json\*](carbonio/configure-module.json "open original schema") |

## timezone Type

`string`

## timezone Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^[A-Za-z0-9_+/-]+$
```

[try pattern](https://regexr.com/?expression=%5E%5BA-Za-z0-9_%2B%2F-%5D%2B%24 "try regular expression with regexr.com")
