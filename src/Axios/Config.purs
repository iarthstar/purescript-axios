module Axios.Config where

import Prelude (($), (<<<))

import Foreign.Generic (class Encode, encode)

import Axios.Types (Config(..), Header, Method)

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