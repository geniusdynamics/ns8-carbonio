# Untitled integer in Configure Carbonio Schema

```txt
http://schema.nethserver.org/carbonio/configure-module.json#/properties/mailbox_heap_mb
```

Java heap of the mailbox service, in MiB (default 1536)

| Abstract            | Extensible | Status         | Identifiable            | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                       |
| :------------------ | :--------- | :------------- | :---------------------- | :---------------- | :-------------------- | :------------------ | :------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | Unknown identifiability | Forbidden         | Allowed               | none                | [configure-module.json\*](carbonio/configure-module.json "open original schema") |

## mailbox_heap_mb Type

`integer`

## mailbox_heap_mb Constraints

**maximum**: the value of this number must smaller than or equal to: `65536`

**minimum**: the value of this number must greater than or equal to: `512`
