{-# LANGUAGE OverloadedStrings #-}

module Database where

import Database.HDBC.MySql
import Database.HDBC

import Control.Monad

import Data.Text.Lazy (Text, unpack, pack)

-- The database connection
dbConnection :: IO Connection
dbConnection =
  connectMySQL defaultMySQLConnectInfo {
    mysqlHost     = "127.0.0.1",
    mysqlUser     = "root",
    mysqlPassword = "sqlserver"
  }

-- Getting a url from a shurl
getUrl :: Text -> IO (Maybe Text)
getUrl shurl = do
  db <- dbConnection
  res <- quickQuery db $ "SELECT * FROM redirects WHERE shurl=" ++ show shurl

  case res of
                []  -> return $ Nothing
    ((_:url:[]):[]) -> return $ Just $ pack url

-- Inserting a (shurl, url) pair into the database
putUrl :: (Text, Text) -> IO ()
putUrl (shurl, url) = do
  db <- dbConnection
  runRaw db "INSERT INTO redirects values(" ++ show shurl ++ ", " ++ show url ++ ")"

-- Generating the next key
nextKey :: IO Text
nextKey = "c"