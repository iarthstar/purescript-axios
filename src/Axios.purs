module Axios where

import Prelude

import Control.Monad.Except (runExcept)
import Data.Either (Either(..))
import Effect (Effect)
import Effect.Aff (Aff, makeAff, nonCanceler)
import Foreign (Foreign)
import Foreign.Class (class Decode, class Encode, decode, encode)

foreign import axios :: String -> String -> Foreign -> (Foreign -> Effect Unit) -> Effect Unit

class Axios req res where
  callApi :: String -> Method -> req -> Aff (Either String res)

data Method
  = GET
  | POST
  | PUT
  | DELETE

instance showMethod :: Show Method where
  show a = case a of
    GET -> "get"
    POST -> "post"
    PUT -> "put"
    DELETE -> "delete"

genericCallApi :: forall a b. Decode b => Encode a => String -> Method -> a -> Aff (Either String b)
genericCallApi url method body = do
  a <- makeAff (\sc -> axios url (show method) (encode body) (Right >>> sc) *> pure nonCanceler)
  pure $ case runExcept $ decode a of
    Right x -> Right x
    Left _ -> Left ""