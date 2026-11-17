# Untitled string in Configure Carbonio Schema

```txt
http://schema.nethserver.org/carbonio/configure-module.json#/properties/admin_password
```

Password of the administrator account: required by the first configuration of a standalone or master server, then optional to change it. Never returned.

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                       |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [configure-module.json\*](carbonio/configure-module.json "open original schema") |

## admin_password Type

`string`

## admin_password Constraints

**maximum length**: the maximum number of characters for this string is: `128`

**minimum length**: the minimum number of characters for this string is: `10`

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^[A-Za-z0-9!#%&()*+,./:;<=>?@^_{|}~\[\]-]+$
```

[try pattern](https://regexr.com/?expression=%5E%5BA-Za-z0-9!%23%25%26\(\)*%2B%2C.%2F%3A%3B%3C%3D%3E%3F%40%5E_%7B%7C%7D~%5C%5B%5C%5D-%5D%2B%24 "try regular expression with regexr.com")
