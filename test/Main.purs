module Test.Main where

import Axios (class Axios, axios, defaultAxios)
import Axios.Types (Method(..))

import Data.Either (Either(..))
import Data.Generic.Rep (class Generic)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class.Console (log, logShow)
import Foreign.Generic (class Decode, class Encode, defaultOptions, genericDecode, genericEncode)
import Prelude (Unit, discard, show, ($), (<>), (>>=))
import Test.Types (DeleteUserReq(..), DeleteUserRes(..), PatchUserInfoReq(..), PatchUserInfoRes(..), SingleUserReq(..), SingleUserRes(..))

newtype GetReleaseInfoReq = GetReleaseInfoReq
  { username :: String
  , reponame :: String
  }
derive instance genericGetReleaseInfoReq :: Generic GetReleaseInfoReq _
instance encodeGetReleaseInfoReq :: Encode GetReleaseInfoReq where encode = genericEncode (defaultOptions { unwrapSingleConstructors = true })

newtype GetReleaseInfoRes = GetReleaseInfoRes
  { total_download_count :: Int
  }
derive instance genericGetReleaseInfoRes :: Generic GetReleaseInfoRes _
instance encodeGetReleaseInfoRes :: Decode GetReleaseInfoRes where decode = genericDecode (defaultOptions { unwrapSingleConstructors = true })

-- | Axios instance for GetReleaseInfo API
instance axiosGetReleaseInfo :: Axios GetReleaseInfoReq GetReleaseInfoRes where 
  axios = defaultAxios "https://grandeur-backend.herokuapp.com/gh_api/get_release_info/" POST

main :: Effect Unit
main = launchAff_ do
  -- | POST API
  let configPost = GetReleaseInfoReq { username : "iarthstar", reponame : "shadows-utilities" }
  axios configPost >>= case _ of
    Right (GetReleaseInfoRes a) -> log $ "POST ----> " <> show a.total_download_count
    Left err -> logShow err

  -- | GET API 
  let configGetRouteParam = SingleUserReq "7" {}
  axios configGetRouteParam >>= case _ of
    Right (SingleUserRes a) -> log $ "GET -----> " <> show a
    Left err -> logShow err

  -- | PATCH API
  let configPatch = PatchUserInfoReq { name : "Arth K. Gajjar", job : "Developer" }
  axios configPatch >>= case _ of
    Right (PatchUserInfoRes a) -> log $ "PATCH ----> " <> show a
    Left err -> logShow err

  -- | DELETE API
  let configDelete = DeleteUserReq "9" {}
  axios configDelete >>= case _ of
    Right (DeleteUserRes a) -> log $ "DELETE --> " <> show a
    Left err -> logShow err