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
  let configGet = Config 
        { url : (userIdUrl 1)
        , method : GET
        , data : SingleUserReq {}
        , headers : [ Header "Content-Type" "application/json" ]
        }
  axios configGet >>= case _ of
    Right (SingleUserRes a) -> log $ "GET : " <> show a
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