module Test.Types where

import Prelude

import Axios (class Axios, defaultAxios', genericAxios)
import Axios.Types (Header(..), Method(..))
import Axios.Config (auth, baseUrl, headers, method)
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

newtype PatchUserInfoReq = PatchUserInfoReq
  { name :: String
  , job :: String
  }
derive instance genericPatchUserInfoReq :: Generic PatchUserInfoReq _
instance encodePatchUserInfoReq :: Encode PatchUserInfoReq where encode = genericEncode (defaultOptions { unwrapSingleConstructors = true })

newtype PatchUserInfoRes = PatchUserInfoRes
  { name :: String
  , job :: String
  , updatedAt :: String
  }
derive instance genericPatchUserInfoRes :: Generic PatchUserInfoRes _
instance decodePatchUserInfoRes :: Decode PatchUserInfoRes where decode = genericDecode (defaultOptions { unwrapSingleConstructors = true })
instance showPatchUserInfoRes :: Show PatchUserInfoRes where show = genericShow

-- | Axios instance for PatchUserInfo API
instance axiosUpdateUserReq :: Axios PatchUserInfoReq PatchUserInfoRes where 
  axios = defaultAxios' "https://reqres.in/api/users/2" PATCH [ Header "Content-Type" "application/json"]

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