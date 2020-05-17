module Axios.Types where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Newtype (class Newtype)
import Effect (Effect)
import Foreign (Foreign)
import Foreign.Generic (class Decode, class Encode, defaultOptions, genericDecode, genericEncode)
import Foreign.Generic.EnumEncoding (genericEncodeEnum)



-- | The `Config` is a product type for wrapping a pair of String and Foreign value,
-- | as key value pairs forming config json for axios
data Config = Config String Foreign
derive instance genericConfig :: Generic Config _
instance encodeConfig :: Encode Config where 
  encode = genericEncode (defaultOptions { unwrapSingleConstructors = true })



-- | The `Header` is simple product type for wrapping a pair of string values,
-- | as key value pairs forming headers json
data Header = Header String String
derive instance genericHeader :: Generic Header _
instance encodeHeader :: Encode Header where 
  encode = genericEncode (defaultOptions { unwrapSingleConstructors = true })



-- | The `Method` type is used to represent common HTTP methods
data Method = GET | POST | PUT | PATCH | DELETE
derive instance genericMethod :: Generic Method _
instance encodeMethod :: Encode Method where 
  encode = genericEncodeEnum { constructorTagTransform: identity }



-- | Response type from axios api call
newtype Response = Response
  { status :: Int
  , statusText :: String
  , data :: Foreign
  }
derive instance newtypeResponse :: Newtype Response _
derive instance genericResponse :: Generic Response _
instance decodeResponse :: Decode Response where decode = genericDecode (defaultOptions { unwrapSingleConstructors = true })

-- | ProgressEvent type for onDownloadProgress and onUploadProgress Events
newtype ProgressEvent = ProgressEvent
  { loaded :: Int
  , total :: Int
  }

-- | APIs Events i.e. Progress Events
data Event
  = UploadProgress (ProgressEvent -> Effect Unit)
  | DownloadProgress (ProgressEvent -> Effect Unit)
