{-# LANGUAGE OverloadedStrings #-}

module Database where

import Database.HDBC.Sqlite3
import Database.HDBC

import Control.Monad

import Data.Text.Lazy (Text, unpack, pack)
import Data.List (sort)

-- The database connection
dbConnection :: IO Connection
dbConnection = connectSqlite3 "./redirects.db"

-- Converting SqlValues into Strings
toStrings :: [[SqlValue]] -> [[String]]
toStrings l =
  map (map (\x -> fromSql x :: String)) l

-- Getting a url from a shurl
getUrl :: Text -> IO (Maybe Text)
getUrl shurl = do
  db <- dbConnection
  res <- quickQuery' db ("SELECT * FROM redirects WHERE shurl==" ++ show shurl) []
  commit db

  if res == []
    then return Nothing
    else return $ Just $ pack (fromSql $ last $ head res :: String)

-- Inserting a (shurl, url) pair into the database
putUrl :: (Text, Text) -> IO ()
putUrl (shurl, url) = do
  db <- dbConnection
  quickQuery' db ("INSERT INTO redirects values(" ++ show shurl ++ ", " ++ show url ++ ")") []
  commit db

-- Generating the next key
nextKey :: IO Text
nextKey = do
  db <- dbConnection
  res <- quickQuery' db ("SELECT * FROM redirects") []
  commit db

  if res == []
    then return "a"
    else let fres = last $ sort $ map (head) $ toStrings res in do
      if last fres == 'z'
        then return $ pack $ fres ++ "a"
        else return $ pack $ (init fres) ++ [(succ $ head fres)]