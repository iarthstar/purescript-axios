module Test.Main where

import Prelude

import Axios (class Axios, Method(..), axios, genericAxios)
import Data.Either (Either(..))
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class.Console (logShow)
import Foreign.Generic (class Decode, class Encode, defaultOptions, genericDecode, genericEncode)

newtype CreateUserReq = CreateUserReq
  { name :: String
  , job :: String
  }

derive instance genericCreateUserReq :: Generic CreateUserReq _
instance decodeCreateUserReq :: Encode CreateUserReq where encode = genericEncode (defaultOptions { unwrapSingleConstructors = true })

newtype CreateUserResp = CreateUserResp
  { name :: String
  , job :: String
  , id :: String
  , createdAt :: String
  }

derive instance genericCreateUserResp :: Generic CreateUserResp _
instance decodeCreateUserResp :: Decode CreateUserResp where decode = genericDecode (defaultOptions { unwrapSingleConstructors = true })
instance showCreateUserResp :: Show CreateUserResp where show = genericShow

baseUrl :: String
baseUrl = "https://reqres.in/api"

createUserUrl :: String
createUserUrl = baseUrl <> "/users"

instance axiosCreateUserReq :: Axios CreateUserReq CreateUserResp where axios = genericAxios

main :: Effect Unit
main = launchAff_ do
  let createUserReq = CreateUserReq { name : "Arth K. Gajjar", job : "Creator" }
  
  axios createUserUrl POST createUserReq >>= case _ of
    Right (CreateUserResp a) -> logShow a
    Left err -> logShow err