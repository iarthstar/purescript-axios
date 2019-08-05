module Test.Main where

import Prelude

import Axios (Config(..), Header(..), Method(..), axios)
import Data.Either (Either(..))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class.Console (log, logShow)
import Test.Types (CreateUserReq(..), CreateUserRes(..), DeleteUserReq(..), DeleteUserRes(..), ListUsersReq(..), ListUsersRes(..), SingleUserReq(..), SingleUserRes(..), UpdateUserReq(..), UpdateUserRes(..))
import Test.Utils (userIdUrl, userUrl)

main :: Effect Unit
main = launchAff_ do
  let configListUsers = Config 
        { url : userUrl
        , method : GET
        , data : ListUsersReq { page : 3 }
        , headers : 
          [ Header "Content-Type" "application/json"
          , Header "Accept" "application/json"
          ]
        }
  axios configListUsers >>= case _ of
    Right (ListUsersRes a) -> log $ "GET : " <> show a
    Left err -> logShow err

  let configGet = Config 
        { url : (userIdUrl 1)
        , method : GET
        , data : SingleUserReq {}
        , headers : [ Header "Content-Type" "application/json" ]
        }
  axios configGet >>= case _ of
    Right (SingleUserRes a) -> log $ "GET : " <> show a
    Left err -> logShow err

  let configPost = Config 
        { url : userUrl
        , method : POST
        , data : CreateUserReq { name : "Arth K. Gajjar", job : "Developer" }
        , headers : [ Header "Content-Type" "application/json" ]
        }
  axios configPost >>= case _ of
    Right (CreateUserRes a) -> log $ "POST : " <> show a
    Left err -> logShow err

  let configPut = Config 
        { url : (userIdUrl 1)
        , method : PUT
        , data : UpdateUserReq { name : "Arth K. Gajjar", job : "Creator" }
        , headers : [ Header "Content-Type" "application/json" ]
        }
  axios configPut >>= case _ of
    Right (UpdateUserRes a) -> log $ "PUT : " <> show a
    Left err -> logShow err

  let configDelete = Config 
        { url : (userIdUrl 1)
        , method : DELETE
        , data : DeleteUserReq {}
        , headers : [ Header "Content-Type" "application/json" ]
        }
  axios configDelete >>= case _ of
    Right (DeleteUserRes a) -> log $ "DELETE : " <> show a
    Left err -> logShow err