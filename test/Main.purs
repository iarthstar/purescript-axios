module Test.Main where

import Prelude

import Axios (Method(..), axios)
import Data.Either (Either(..))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class.Console (log, logShow)
import Test.Types (CreateUserReq(..), CreateUserResp(..), DeleteUserReq(..), DeleteUserResp(..), SingleUserReq(..), SingleUserResp(..), UpdateUserReq(..), UpdateUserResp(..))
import Test.Utils (userIdUrl, userUrl)

main :: Effect Unit
main = launchAff_ do
  let singleUserReq = SingleUserReq {}
  axios (userIdUrl 1) GET singleUserReq >>= case _ of
    Right (SingleUserResp a) -> log $ "GET : " <> show a
    Left err -> logShow err

  let createUserReq = CreateUserReq { name : "Arth K. Gajjar", job : "Developer" }
  axios userUrl POST createUserReq >>= case _ of
    Right (CreateUserResp a) -> log $ "POST : " <> show a
    Left err -> logShow err

  let updateUserReq = UpdateUserReq { name : "Arth K. Gajjar", job : "Creator" }
  axios (userIdUrl 1) PUT updateUserReq >>= case _ of
    Right (UpdateUserResp a) -> log $ "PUT : " <> show a
    Left err -> logShow err

  let deleteUserReq = DeleteUserReq {}
  axios (userIdUrl 1) DELETE deleteUserReq >>= case _ of
    Right (DeleteUserResp a) -> log $ "DELETE : " <> show a
    Left err -> logShow err