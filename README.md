# purescript-axios

axios.js bindings for PureScript

## Add purescript-axios to your existing projects

```
bower i purescript-axios
```

## Code Snippet

```purescript
instance axiosCreateUserReq :: Axios CreateUserReq CreateUserResp where axios = genericAxios

main :: Effect Unit
main = launchAff_ do
  let createUserReq = CreateUserReq { name : "Arth K. Gajjar", job : "Creator" }
  
  axios createUserUrl POST createUserReq >>= case _ of
    Right (CreateUserResp a) -> logShow a
    Left err -> logShow err
```

## Development Guide

#### NOTE : Please make sure you have yarn :: [Installing yarn](https://yarnpkg.com/en/docs/install)

* Build Project

```bash
$ yarn build
```

* To Test

```bash
$ yarn test
```

* To watch for changes

```bash
$ yarn start
```