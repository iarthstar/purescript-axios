# purescript-axios

Axios JS bindings for PureScript

- [Module Documentation](https://pursuit.purescript.org/packages/purescript-axios/)
- [Example](https://github.com/iarthstar/purescript-axios/blob/master/test/Main.purs)

## Add purescript-axios to your existing projects

```bash
bower i purescript-axios
```

## Code Snippet

```purescript
newtype GetReleaseInfoReq = GetReleaseInfoReq
  { username :: String
  , reponame :: String
  }
derive instance genericGetReleaseInfoReq :: Generic GetReleaseInfoReq _
instance encodeGetReleaseInfoReq :: Encode GetReleaseInfoReq where 
  encode = genericEncode (defaultOptions { unwrapSingleConstructors = true })

newtype GetReleaseInfoRes = GetReleaseInfoRes
  { total_download_count :: Int
  }
derive instance genericGetReleaseInfoRes :: Generic GetReleaseInfoRes _
instance encodeGetReleaseInfoRes :: Decode GetReleaseInfoRes where 
  decode = genericDecode (defaultOptions { unwrapSingleConstructors = true })

-- | Axios instance for GetReleaseInfo API
instance axiosGetReleaseInfo :: Axios GetReleaseInfoReq GetReleaseInfoRes where 
  axios = defaultAxios "https://grandeur-backend.herokuapp.com/gh_api/get_release_info/" POST

main :: Effect Unit
main = launchAff_ do
  let configPost = GetReleaseInfoReq { username : "iarthstar", reponame : "shadows-utilities" }
  axios configPost >>= case _ of
    Right (GetReleaseInfoRes a) -> log $ "POST ----> " <> show a.total_download_count
    Left err -> logShow err
```

## Development Guide

#### NOTE : Please make sure you have yarn :: [Installing yarn](https://yarnpkg.com/en/docs/install)

* Build Project

```bash
$ yarn install
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
