module Test.Utils where

import Prelude

baseUrl :: String
baseUrl = "https://reqres.in/api"

userUrl :: String
userUrl = baseUrl <> "/users"

userIdUrl :: Int -> String
userIdUrl a = userUrl <> "/" <> show a