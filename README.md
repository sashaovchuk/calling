# calling

For show calling screen on iOS

## Install

```bash
npm install calling
npx cap sync
```

## API

<docgen-index>

* [`echo(...)`](#echo)
* [`getVoIPToken()`](#getvoiptoken)
* [`outcomingCall(...)`](#outcomingcall)
* [`incomingCall(...)`](#incomingcall)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### echo(...)

```typescript
echo(options: { value: string; }) => Promise<{ value: string; }>
```

| Param         | Type                            |
| ------------- | ------------------------------- |
| **`options`** | <code>{ value: string; }</code> |

**Returns:** <code>Promise&lt;{ value: string; }&gt;</code>

--------------------


### getVoIPToken()

```typescript
getVoIPToken() => Promise<{ token: string; }>
```

**Returns:** <code>Promise&lt;{ token: string; }&gt;</code>

--------------------


### outcomingCall(...)

```typescript
outcomingCall(call: { username: string; video: boolean; }) => Promise<{ status: string; }>
```

| Param      | Type                                               |
| ---------- | -------------------------------------------------- |
| **`call`** | <code>{ username: string; video: boolean; }</code> |

**Returns:** <code>Promise&lt;{ status: string; }&gt;</code>

--------------------


### incomingCall(...)

```typescript
incomingCall(call: { username: string; video: boolean; }) => Promise<{ status: string; }>
```

| Param      | Type                                               |
| ---------- | -------------------------------------------------- |
| **`call`** | <code>{ username: string; video: boolean; }</code> |

**Returns:** <code>Promise&lt;{ status: string; }&gt;</code>

--------------------

</docgen-api>
