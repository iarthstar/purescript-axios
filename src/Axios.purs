module Axios where

import Prelude

import Control.Monad.Except (runExcept)
import Data.Either (Either(..))
import Data.Generic.Rep (class Generic)
import Data.Newtype (class Newtype)
import Effect.Aff (Aff, Error, attempt, error)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)
import Foreign (Foreign)
import Foreign.Generic (class Decode, class Encode, decode, defaultOptions, encode, genericDecode, genericEncode)
import Foreign.Generic.EnumEncoding (genericEncodeEnum)

foreign import _axios :: String -> Foreign -> Foreign -> EffectFnAff Response

class Axios req res | req -> res where
  axios :: req -> Aff (Either Error res)




-- | Types ------------------------------------------------------------------------------------------------------------

data Config = Config String Foreign
derive instance genericConfig :: Generic Config _
instance encodeConfig :: Encode Config where 
  encode = genericEncode (defaultOptions { unwrapSingleConstructors = true })

data Header = Header String String
derive instance genericHeader :: Generic Header _
instance encodeHeader :: Encode Header where 
  encode = genericEncode (defaultOptions { unwrapSingleConstructors = true })

data Method = GET | POST | PUT | PATCH | DELETE
derive instance genericMethod :: Generic Method _
instance encodeMethod :: Encode Method where 
  encode = genericEncodeEnum { constructorTagTransform: identity }

newtype Response = Response
  { status :: Int
  , statusText :: String
  , data :: Foreign
  }
derive instance newtypeResponse :: Newtype Response _
derive instance genericResponse :: Generic Response _
instance decodeResponse :: Decode Response where decode = genericDecode (defaultOptions { unwrapSingleConstructors = true })




-- | Config -----------------------------------------------------------------------------------------------------------

method :: Method -> Config
method = Config "method" <<< encode 

baseUrl :: String -> Config
baseUrl = Config "baseURL" <<< encode

timeout :: Int -> Config
timeout = Config "timeout" <<< encode

body :: forall req. Encode req => req -> Config
body = Config "data" <<< encode

auth :: String -> String -> Config
auth username password = Config "auth" $ encode { username, password }

headers :: Array Header -> Config
headers = Config "headers" <<< encode




-- | Helpers ----------------------------------------------------------------------------------------------------------

genericAxios :: forall req res. Decode res => Encode req => String -> Array Config -> req -> Aff (Either Error res)
genericAxios urlStr configArr req = do
  attempt (fromEffectFnAff $ _axios urlStr (encode configArr) (encode req)) <#> responseToNewtype

defaultFetch :: forall req res. Decode res => Encode req => String -> Method -> req -> Aff (Either Error res)
defaultFetch urlStr methodType req = do
  let configF = encode [ method methodType ]
  attempt (fromEffectFnAff $ _axios urlStr configF (encode req)) <#> responseToNewtype

defaultFetch' :: forall req res. Decode res => Encode req => String -> Method -> Array Header -> req -> Aff (Either Error res)
defaultFetch' urlStr methodType headersArr req = do
  let configF = encode [ method methodType, headers headersArr ]
  attempt (fromEffectFnAff $ _axios urlStr configF (encode req)) <#> responseToNewtype

responseToNewtype :: forall res. Decode res => Either Error Response -> Either Error res
responseToNewtype = case _ of
  Right (Response a) -> case runExcept $ decode a.data of
    Right x -> Right x
    Left err -> Left $ error $ show err
  Left err ->  Left err