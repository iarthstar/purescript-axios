module Axios where

import Prelude

import Control.Monad.Except (runExcept)
import Data.Either (Either(..))
import Data.Generic.Rep (class Generic)
import Effect.Aff (Aff, Error, attempt, error)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)
import Foreign (Foreign)
import Foreign.Generic (class Decode, class Encode, decode, defaultOptions, encode, genericEncode)
import Foreign.Generic.EnumEncoding (genericEncodeEnum)

foreign import _axios :: Foreign -> EffectFnAff Foreign

class Axios req res where
  axios :: Config req -> Aff (Either Error res)

data Method
  = GET
  | POST
  | PUT
  | DELETE

derive instance genericMethod :: Generic Method _
instance encodeMethod :: Encode Method where encode = genericEncodeEnum { constructorTagTransform: identity }

data Header = Header String String
derive instance genericHeader :: Generic Header _
instance decodeConfig :: Encode Header where encode = genericEncode (defaultOptions { unwrapSingleConstructors = true })

newtype Config req = Config
  { url :: String
  , method :: Method 
  , data :: req
  , headers :: Array Header
  }
derive instance genericConfig :: Generic (Config req) _
instance encodeConfig :: Encode req => Encode (Config req) where encode = genericEncode (defaultOptions { unwrapSingleConstructors = true })

genericAxios :: forall req res. Decode res => Encode req => Config req -> Aff (Either Error res)
genericAxios config = attempt (fromEffectFnAff $ _axios (encode config)) <#> case _ of
  Right a -> case runExcept $ decode a of
    Right x -> Right x
    Left err -> Left $ error $ show err
  Left err ->  Left err