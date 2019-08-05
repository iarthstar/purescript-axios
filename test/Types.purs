module Test.Types where

import Prelude

import Axios (class Axios, genericAxios)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Foreign.Generic (class Decode, class Encode, defaultOptions, genericDecode, genericEncode)

newtype CreateUserReq = CreateUserReq
  { name :: String
  , job :: String
  }
derive instance genericCreateUserReq :: Generic CreateUserReq _
instance decodeCreateUserReq :: Encode CreateUserReq where encode = genericEncode (defaultOptions { unwrapSingleConstructors = true })

newtype CreateUserResp = CreateUserResp
  { name :: String
  , job :: String
  , id :: String
  , createdAt :: String
  }
derive instance genericCreateUserResp :: Generic CreateUserResp _
instance decodeCreateUserResp :: Decode CreateUserResp where decode = genericDecode (defaultOptions { unwrapSingleConstructors = true })
instance showCreateUserResp :: Show CreateUserResp where show = genericShow

-- | Axios instance for CreateUser API
instance axiosCreateUserReq :: Axios CreateUserReq CreateUserResp where axios = genericAxios

data SingleUserReq = SingleUserReq {}
derive instance genericSingleUserReq :: Generic SingleUserReq _
instance decodeSingleUserReq :: Encode SingleUserReq where encode = genericEncode (defaultOptions { unwrapSingleConstructors = true })

newtype SingleUserResp = SingleUserResp
  { data :: 
    { id :: Int
    , email :: String
    , first_name :: String
    , last_name :: String
    , avatar :: String
    }
  }
derive instance genericSingleUserResp :: Generic SingleUserResp _
instance decodeSingleUserResp :: Decode SingleUserResp where decode = genericDecode (defaultOptions { unwrapSingleConstructors = true })
instance showSingleUserResp :: Show SingleUserResp where show = genericShow

-- | Axios instance for SingleUser API
instance axiosSingleUserReq :: Axios SingleUserReq SingleUserResp where axios = genericAxios

newtype UpdateUserReq = UpdateUserReq
  { name :: String
  , job :: String
  }
derive instance genericUpdateUserReq :: Generic UpdateUserReq _
instance decodeUpdateUserReq :: Encode UpdateUserReq where encode = genericEncode (defaultOptions { unwrapSingleConstructors = true })

newtype UpdateUserResp = UpdateUserResp
  { name :: String
  , job :: String
  , updatedAt :: String
  }
derive instance genericUpdateUserResp :: Generic UpdateUserResp _
instance decodeUpdateUserResp :: Decode UpdateUserResp where decode = genericDecode (defaultOptions { unwrapSingleConstructors = true })
instance showUpdateUserResp :: Show UpdateUserResp where show = genericShow

-- | Axios instance for UpdateUser API
instance axiosUpdateUserReq :: Axios UpdateUserReq UpdateUserResp where axios = genericAxios

data DeleteUserReq = DeleteUserReq {}
derive instance genericDeleteUserReq :: Generic DeleteUserReq _
instance decodeDeleteUserReq :: Encode DeleteUserReq where encode = genericEncode (defaultOptions { unwrapSingleConstructors = true })

newtype DeleteUserResp = DeleteUserResp String
derive instance genericDeleteUserResp :: Generic DeleteUserResp _
instance decodeDeleteUserResp :: Decode DeleteUserResp where decode = genericDecode (defaultOptions { unwrapSingleConstructors = true })
instance showDeleteUserResp :: Show DeleteUserResp where show = genericShow

-- | Axios instance for DeleteUser API
instance axiosDeleteUserReq :: Axios DeleteUserReq DeleteUserResp where axios = genericAxios