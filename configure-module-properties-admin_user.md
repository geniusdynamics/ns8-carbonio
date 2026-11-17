# Untitled string in Configure Carbonio Schema

```txt
http://schema.nethserver.org/carbonio/configure-module.json#/properties/admin_user
```

Local part of the administrator account, first configuration only (default admin)

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                       |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [configure-module.json\*](carbonio/configure-module.json "open original schema") |

## admin_user Type

`string`

## admin_user Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^[a-z0-9][a-z0-9._-]{0,63}$
```

[try pattern](https://regexr.com/?expression=%5E%5Ba-z0-9%5D%5Ba-z0-9._-%5D%7B0%2C63%7D%24 "try regular expression with regexr.com")
