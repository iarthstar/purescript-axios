module Axios 
  ( axios
  , class Axios
  , Header(..)
  , Method(..)
  , Config(..)
  , method
  , baseUrl
  , timeout
  , auth
  , headers
  , genericAxios
  , defaultFetch
  , defaultFetch'
  ) where

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

-- | The `Axios` type class is for performing api calls 
-- | using Axios JS
class Axios req res | req -> res where
  axios :: req -> Aff (Either Error res)




-- | Types ------------------------------------------------------------------------------------------------------------

-- | The `Config` is a product type for wrapping a pair of String and Foreign value,
-- | as key value pairs forming config json for axios
data Config = Config String Foreign
derive instance genericConfig :: Generic Config _
instance encodeConfig :: Encode Config where 
  encode = genericEncode (defaultOptions { unwrapSingleConstructors = true })


-- | The `Header` is simple product type for wrapping a pair of string values,
-- | as key value pairs forming headers json
data Header = Header String String
derive instance genericHeader :: Generic Header _
instance encodeHeader :: Encode Header where 
  encode = genericEncode (defaultOptions { unwrapSingleConstructors = true })

-- | The `Method` type is used to represent common HTTP methods
data Method = GET | POST | PUT | PATCH | DELETE
derive instance genericMethod :: Generic Method _
instance encodeMethod :: Encode Method where 
  encode = genericEncodeEnum { constructorTagTransform: identity }

-- | Response type from axios api call
newtype Response = Response
  { status :: Int
  , statusText :: String
  , data :: Foreign
  }
derive instance newtypeResponse :: Newtype Response _
derive instance genericResponse :: Generic Response _
instance decodeResponse :: Decode Response where decode = genericDecode (defaultOptions { unwrapSingleConstructors = true })




-- | Config -----------------------------------------------------------------------------------------------------------

-- | Converts an `Method` value into a `Config` with key method
method :: Method -> Config
method = Config "method" <<< encode 

-- | Converts an `String` value into a `Config` with key baseURL
baseUrl :: String -> Config
baseUrl = Config "baseURL" <<< encode

-- | Converts an `Int` value into a `Config` with key timeout
timeout :: Int -> Config
timeout = Config "timeout" <<< encode

-- | Converts an `req` value into a `Config` with key data
body :: forall req. Encode req => req -> Config
body = Config "data" <<< encode

-- | Constructs a `Config` with key auth from pair of String values i.e. username and password
auth :: String -> String -> Config
auth username password = Config "auth" $ encode { username, password }

-- | Constructs a `Config` with key headers from an array of `Header` 
headers :: Array Header -> Config
headers = Config "headers" <<< encode




-- | Helpers ----------------------------------------------------------------------------------------------------------

-- | A generic implementation of the `axios` member from `Axios` class 
-- | i.e. takes an url, array of config and request body and gives the `Either` `Error` response 
genericAxios :: forall req res. Decode res => Encode req => String -> Array Config -> req -> Aff (Either Error res)
genericAxios urlStr configArr req = do
  attempt (fromEffectFnAff $ _axios urlStr (encode configArr) (encode req)) <#> responseToNewtype

-- | A default implementation of the `axios` member from `Axios` class
-- | i.e. takes an url, method and request body and gives the `Either` `Error` response 
defaultFetch :: forall req res. Decode res => Encode req => String -> Method -> req -> Aff (Either Error res)
defaultFetch urlStr methodType req = do
  let configF = encode [ method methodType ]
  attempt (fromEffectFnAff $ _axios urlStr configF (encode req)) <#> responseToNewtype

-- | Another default implementation of the `axios` member from `Axios` class
-- | i.e. takes an url, method, array of header and request body and gives the `Either` `Error` response 
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