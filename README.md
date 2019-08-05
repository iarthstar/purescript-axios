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
  let configPost = Config 
        { url : userUrl
        , method : POST
        , data : CreateUserReq { name : "Arth K. Gajjar", job : "Developer" }
        , headers : [ Header "Content-Type" "application/json" ]
        }
  axios configPost >>= case _ of
    Right (CreateUserRes a) -> log $ "POST : " <> show a
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