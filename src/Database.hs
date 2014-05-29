{-# LANGUAGE OverloadedStrings #-}

module Database where

import Database.HDBC.Sqlite3
import Database.HDBC

import Control.Monad

import Data.Text.Lazy (Text, unpack, pack)

-- The database connection
dbConnection :: IO Connection
dbConnection = connectSqlite3 "./redirects.db"

-- Getting a url from a shurl
getUrl :: Text -> IO (Maybe Text)
getUrl shurl = do
  db <- dbConnection
  res <- quickQuery db ("SELECT * FROM redirects WHERE shurl==" ++ show shurl) []

  if res == []
    then return Nothing
    else return $ Just $ pack (fromSql $ last $ head res :: String)

-- Inserting a (shurl, url) pair into the database
putUrl :: (Text, Text) -> IO ()
putUrl (shurl, url) = do
  db <- dbConnection
  run db ("INSERT INTO redirects values(" ++ show shurl ++ ", " ++ show url ++ ")") []
  commit db

-- Generating the next key
nextKey :: IO Text
nextKey = return "b"