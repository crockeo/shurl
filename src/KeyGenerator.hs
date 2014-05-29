{-# LANGUAGE OverloadedStrings #-}

module KeyGenerator where

import qualified Data.Text.Lazy as T
import Data.List

-- A list of possible keys
possibleKeys :: [T.Text]
possibleKeys = map T.pack $ tail $ subsequences "abcdefghijklmnopqrstuvwxyz0123456789"

-- Getting the next key from a key
nextKey :: T.Text -> T.Text
nextKey t =
  case elemIndex t possibleKeys of
    Nothing -> error "Invaild key exists within the database."
    Just n  -> possibleKeys !! (n + 1)