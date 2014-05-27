{-# LANGUAGE OverloadedStrings #-}

module Database where

import System.Directory

import Data.Text.Lazy (Text, unpack, pack)
import Data.IORef

import Control.Monad

type Database = [(Text, Text)]

------------------------------------
-- Database Loading / Information --

-- Parsing a database from a string
parseDatabase :: String -> Database
parseDatabase string =
  map makePair $ lines string
  where makePair :: String -> (Text, Text)
        makePair s =
          (pack sh, pack lo)
          where (sh:lo:[]) = words s

-- Loading a database from a file
load :: FilePath -> IO Database
load fp = do
  fe <- doesFileExist fp

  liftM (parseDatabase) $
    if fe
      then readFile fp
      else return ""

-- Caching a database
cache :: FilePath -> Database -> IO ()
cache fp db =
  writeFile fp $ showDatabase db
  where showDatabase :: Database -> String
        showDatabase []          = ""
        showDatabase ((k, v):[]) = unpack k ++ " " ++ unpack v
        showDatabase ((k, v):xs) = unpack k ++ " " ++ unpack v ++ "\n" ++ showDatabase xs

-----------------------
-- Database Instance --

-- The database file name
databaseLocation :: String
databaseLocation = "database.db"

-- The instance itself
database :: IO (IORef Database)
database = load databaseLocation >>= newIORef

-- Caching the database instance
cacheDB :: IO ()
cacheDB = database >>= readIORef >>= cache databaseLocation

-------------------------
-- Database Operations --

-- Getting a URL from a given key in a database
getUrl :: Text -> Database -> Maybe Text
getUrl t []          = Nothing
getUrl t ((k, v):xs) =
  if k == t
    then Just v
    else getUrl t xs

-- Putting a (key, URL) pair into a database
putUrl :: (Text, Text) -> Database -> Database
putUrl p db = p : db

-- Getting a pair from the database
getUrlIO :: Text -> IO (Maybe Text)
getUrlIO t = (database >>= readIORef) >>= return . getUrl t

-- Putting a pair into the database
putUrlIO :: (Text, Text) -> IO ()
putUrlIO p = database >>= (\x -> modifyIORef x $ putUrl p)