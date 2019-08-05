module Axios 
  ( class Axios
  , Method(..)
  , axios
  , genericAxios
  ) where

import Prelude

import Control.Monad.Except (runExcept)
import Data.Either (Either(..))
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Effect.Aff (Aff, Error, attempt, error)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)
import Foreign (Foreign)
import Foreign.Generic (class Decode, class Encode, decode, encode)

foreign import _axios :: String -> String -> Foreign -> EffectFnAff Foreign

class Axios req resp where
  axios :: String -> Method -> req -> Aff (Either Error resp)

data Method
  = GET
  | POST
  | PUT
  | DELETE

derive instance genericMethod :: Generic Method _
instance showMethod :: Show Method where show = genericShow

genericAxios :: forall a b. Decode b => Encode a => String -> Method -> a -> Aff (Either Error b)
genericAxios url method body = attempt (fromEffectFnAff $ _axios url (show method) (encode body)) <#> case _ of
  Right a -> case runExcept $ decode a of
    Right x -> Right x
    Left err -> Left $ error $ show err
  Left err ->  Left err