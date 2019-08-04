module Axios 
  ( class Axios
  , Method(..)
  , axios
  , genericAxios
  ) where

import Prelude

import Data.Either (Either)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Effect.Aff (Aff, Error, attempt)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)
import Foreign (Foreign)
import Foreign.Generic (class Encode, encode)

foreign import _axios :: String -> String -> Foreign -> EffectFnAff Foreign

class Axios req where
  axios :: String -> Method -> req -> Aff (Either Error Foreign)

data Method
  = GET
  | POST
  | PUT
  | DELETE

derive instance genericMethod :: Generic Method _
instance showMethod :: Show Method where show = genericShow

genericAxios :: forall a. Encode a => String -> Method -> a -> Aff (Either Error Foreign)
genericAxios url method body = attempt $ fromEffectFnAff $ _axios url (show method) (encode body)