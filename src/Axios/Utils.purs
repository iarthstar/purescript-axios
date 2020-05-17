module Axios.Utils where

import Prelude (show, ($))

import Control.Monad.Except (runExcept)
import Data.Either (Either(..))
import Effect.Aff (Error, error)
import Foreign.Generic (class Decode, decode)

import Axios.Types (Response(..))

responseToNewtype :: forall res. Decode res => Either Error Response -> Either Error res
responseToNewtype = case _ of
  Right (Response a) -> case runExcept $ decode a.data of
    Right x -> Right x
    Left err -> Left $ error $ show err
  Left err ->  Left err