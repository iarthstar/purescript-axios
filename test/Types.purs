module Test.Types where

import Prelude

import Axios (class Axios, Header(..), Method(..), auth, baseUrl, defaultFetch', genericAxios, headers, method)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Foreign.Generic (class Decode, class Encode, defaultOptions, genericDecode, genericEncode)


data SingleUserReq = SingleUserReq String {}
derive instance genericSingleUserReq :: Generic SingleUserReq _
instance encodeSingleUserReq :: Encode SingleUserReq where encode = genericEncode (defaultOptions { unwrapSingleConstructors = true })

newtype SingleUserRes = SingleUserRes
  { id :: String
  , job :: String
  , name :: String
  , created_at :: String
  }
derive instance genericSingleUserRes :: Generic SingleUserRes _
instance decodeSingleUserRes :: Decode SingleUserRes where decode = genericDecode (defaultOptions { unwrapSingleConstructors = true })
instance showSingleUserRes :: Show SingleUserRes where show = genericShow

-- | Axios instance for SingleUser API
instance axiosSingleUserReq :: Axios SingleUserReq SingleUserRes where 
  axios (SingleUserReq url req) = genericAxios ("/req_res/users/" <> url) 
                                    [ method GET
                                    , headers [ Header "Content-Type" "application/json" ]
                                    , baseUrl "https://grandeur-backend.herokuapp.com"
                                    , auth "1234" "1234"
                                    ] req

newtype GetRepoInfoReq = GetRepoInfoReq
  { username :: String
  , reponame :: String
  }
derive instance genericGetRepoInfoReq :: Generic GetRepoInfoReq _
instance encodeGetRepoInfoReq :: Encode GetRepoInfoReq where encode = genericEncode (defaultOptions { unwrapSingleConstructors = true })

newtype GetRepoInfoRes = GetRepoInfoRes
  { reponame :: String
  , description :: String
  , stargazers :: Int
  , watchers :: Int
  , forks :: Int
  , open_issues :: Int
  , is_private :: Boolean
  , language :: String
  }
derive instance genericGetRepoInfoRes :: Generic GetRepoInfoRes _
instance decodeGetRepoInfoRes :: Decode GetRepoInfoRes where decode = genericDecode (defaultOptions { unwrapSingleConstructors = true })
instance showGetRepoInfoRes :: Show GetRepoInfoRes where show = genericShow

-- | Axios instance for GetRepoInfo API
instance axiosUpdateUserReq :: Axios GetRepoInfoReq GetRepoInfoRes where 
  axios = defaultFetch' "https://grandeur-backend.herokuapp.com/gh_api/get_repo_info/" POST [ Header "Content-Type" "application/json"]

data DeleteUserReq = DeleteUserReq String {}
derive instance genericDeleteUserReq :: Generic DeleteUserReq _
instance encodeDeleteUserReq :: Encode DeleteUserReq where encode = genericEncode (defaultOptions { unwrapSingleConstructors = true })

newtype DeleteUserRes = DeleteUserRes {}
derive instance genericDeleteUserRes :: Generic DeleteUserRes _
instance decodeDeleteUserRes :: Decode DeleteUserRes where decode = genericDecode (defaultOptions { unwrapSingleConstructors = true })
instance showDeleteUserRes :: Show DeleteUserRes where show = genericShow

-- | Axios instance for DeleteUser API
instance axiosDeleteUserReq :: Axios DeleteUserReq DeleteUserRes where 
  axios (DeleteUserReq url req) = genericAxios ("/req_res/users/" <> url) 
                                    [ method DELETE
                                    , headers [ Header "Content-Type" "application/json" ]
                                    , baseUrl "https://grandeur-backend.herokuapp.com"
                                    , auth "1234" "1234"
                                    ] req