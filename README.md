# purescript-axios

axios.js bindings for PureScript

## Add purescript-axios to your existing projects

```
bower i purescript-axios
```

## Code Snippet

```purescript
main :: Effect Unit
main = launchAff_ do
  let singleUserReq = SingleUserReq {}
  axios (userIdUrl 1) GET singleUserReq >>= case _ of
    Right (SingleUserResp a) -> log $ "GET : " <> show a
    Left err -> logShow err

  let createUserReq = CreateUserReq { name : "Arth K. Gajjar", job : "Developer" }
  axios userUrl POST createUserReq >>= case _ of
    Right (CreateUserResp a) -> log $ "POST : " <> show a
    Left err -> logShow err

  let updateUserReq = UpdateUserReq { name : "Arth K. Gajjar", job : "Creator" }
  axios (userIdUrl 1) PUT updateUserReq >>= case _ of
    Right (UpdateUserResp a) -> log $ "PUT : " <> show a
    Left err -> logShow err

  let deleteUserReq = DeleteUserReq {}
  axios (userIdUrl 1) DELETE deleteUserReq >>= case _ of
    Right (DeleteUserResp a) -> log $ "DELETE : " <> show a
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