module Test.Main where

import Prelude (Unit, discard, show, ($), (<>), (>>=))

import Axios (axios)
import Data.Either (Either(..))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class.Console (log, logShow)
import Test.Types (DeleteUserReq(..), DeleteUserRes(..), GetRepoInfoReq(..), GetRepoInfoRes(..), SingleUserReq(..), SingleUserRes(..))

main :: Effect Unit
main = launchAff_ do

  -- | GET API 
  let configGetRouteParam = SingleUserReq "7" {}
  axios configGetRouteParam >>= case _ of
    Right (SingleUserRes a) -> log $ "GET -----> " <> show a
    Left err -> logShow err

  -- | POST API
  let configPost = GetRepoInfoReq { username : "iarthstar", reponame : "purs-skpm" }
  axios configPost >>= case _ of
    Right (GetRepoInfoRes a) -> log $ "POST ----> " <> show a
    Left err -> logShow err

  -- | DELETE API
  let configDelete = DeleteUserReq "9" {}
  axios configDelete >>= case _ of
    Right (DeleteUserRes a) -> log $ "DELETE --> " <> show a
    Left err -> logShow err