# purescript-axios

Axios JS bindings for PureScript

## Add purescript-axios to your existing projects

```
bower i purescript-axios
```

## Code Snippet

```purescript
main :: Effect Unit
main = launchAff_ do
  let configPost = GetRepoInfoReq { username : "iarthstar", reponame : "purs-skpm" }
  axios configPost >>= case _ of
    Right (GetRepoInfoRes a) -> log $ "POST ----> " <> show a
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