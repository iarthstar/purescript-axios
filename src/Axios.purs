module Axios where

import Prelude (($), (<#>))

import Data.Either (Either)
import Effect.Aff (Aff, Error, attempt)
import Effect.Aff.Compat (EffectFnAff, fromEffectFnAff)
import Foreign (Foreign)
import Foreign.Generic (class Decode, class Encode, encode)

import Axios.Types (Config, Header, Method, Response)
import Axios.Config (headers, method)
import Axios.Utils

foreign import _axios :: String -> Foreign -> Foreign -> EffectFnAff Response

-- | The `Axios` type class is for performing api calls 
-- | using Axios JS
class Axios req res | req -> res where
  axios :: req -> Aff (Either Error res)




-- | A generic implementation of the `axios` member from `Axios` class 
-- | i.e. takes an url, array of config and request body and gives the `Either` `Error` response 
-- |```purescript
-- |genericAxios "/req_res/users/9" 
-- |  [ method GET
-- |  , headers [ Header "Content-Type" "application/json" ]
-- |  , baseUrl "https://grandeur-backend.herokuapp.com"
-- |  , auth "1234" "1234"
-- |  ] req
-- |```
genericAxios :: forall req res. Decode res => Encode req => String -> Array Config -> req -> Aff (Either Error res)
genericAxios urlStr configArr req = do
  attempt (fromEffectFnAff $ _axios urlStr (encode configArr) (encode req)) <#> responseToNewtype

-- | A default implementation of the `axios` member from `Axios` class
-- | i.e. takes an url, method and request body and gives the `Either` `Error` response 
-- |
-- |```purescript
-- |defaultAxios "https://grandeur-backend.herokuapp.com/gh_api/get_release_info/" POST req
-- |```
defaultAxios :: forall req res. Decode res => Encode req => String -> Method -> req -> Aff (Either Error res)
defaultAxios urlStr methodType req = do
  let configF = encode [ method methodType ]
  attempt (fromEffectFnAff $ _axios urlStr configF (encode req)) <#> responseToNewtype

-- | Another default implementation of the `axios` member from `Axios` class
-- | i.e. takes an url, method, array of header and request body and gives the `Either` `Error` response 
-- |```purescript
-- |defaultAxios' "https://reqres.in/api/users/7" PATCH 
-- |  [ Header "Content-Type" "application/json"
-- |  , Header "Cache-Control" "no-cache"
-- |  ] req
-- |```
defaultAxios' :: forall req res. Decode res => Encode req => String -> Method -> Array Header -> req -> Aff (Either Error res)
defaultAxios' urlStr methodType headersArr req = do
  let configF = encode [ method methodType, headers headersArr ]
  attempt (fromEffectFnAff $ _axios urlStr configF (encode req)) <#> responseToNewtype