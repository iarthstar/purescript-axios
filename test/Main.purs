module Test.Main where

import Prelude

import Data.Either (Either(..))
import Data.Generic.Rep (class Generic)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import Foreign.Class (class Decode, class Encode)
import Foreign.Generic (defaultOptions, genericDecode, genericEncode)
import Axios (class Axios, Method(..), callApi, genericCallApi)

newtype GetInfoReq = GetInfoReq
  { username :: String
  }
derive instance genericGetInfoReq :: Generic GetInfoReq _
instance encodeGetInfoReq :: Encode GetInfoReq where encode = genericEncode (defaultOptions { unwrapSingleConstructors = true })

newtype GetInfoResp = GetInfoResp
  { username :: String
  , posts :: String
  , followers :: String
  , following :: String
  , name :: String
  }
derive instance genericGetInfoResp :: Generic GetInfoResp _
instance decodeGetInfoResp :: Decode GetInfoResp where decode = genericDecode (defaultOptions { unwrapSingleConstructors = true })

getInfoUrl :: String
getInfoUrl = "https://insta-scrapper.herokuapp.com/getInfo"

instance getInfo :: Axios GetInfoReq GetInfoResp where callApi = genericCallApi

main :: Effect Unit
main = do
  let req = GetInfoReq { username : "tarasutaria" }

  launchAff_ $ callApi getInfoUrl POST req >>= liftEffect <<< case _ of
    Right (GetInfoResp x) -> do 
      log $ "Name : " <> x.name
      log $ "Username : " <> x.username
      log $ "Posts : " <> x.posts
      log $ "Followers : " <> x.followers
      log $ "Followings : " <> x.following
    Left _ -> log "Error"

  pure unit