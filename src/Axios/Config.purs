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

type ProxyRecord =
  { host :: String
  , port :: Number }

-- Commented out because this is for Node only!
-- | Constructs a `Config` with a proxy from a URL
-- proxyFromURL :: String -> Config
-- proxyFromURL str =
--   let url = Node.URL.parse str in
--   let port = case Data.Number.parse url.port of
--               Just n -> n
--               Nothing -> 8000
--             in
--   -- let pr = { host: url.hostname, port: port }
--   Config "proxy" $ encode { host: url.hostname, port: port }

-- | Constructs a `Config` with a proxy from hostname and port
proxy :: String -> Int -> Config
proxy hostname port = Config "proxy" $ encode { host:hostname, port: port }
