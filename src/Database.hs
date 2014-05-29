{-# LANGUAGE OverloadedStrings #-}

module Database (getUrl, putUrl) where

import Database.HDBC.Sqlite3
import Database.HDBC

import Control.Monad

import qualified Data.Text.Lazy as T
import Data.List (sort)
import Data.Char

import KeyGenerator

-- The database connection
_dbConnection :: IO Connection
_dbConnection = connectSqlite3 "./redirects.db"

-- Getting the next key from the database
_nextKey :: IO T.Text
_nextKey = do
  db <- _dbConnection
  res <- quickQuery' db ("SELECT * FROM redirects") []
  commit db

  if res == []
    then return "a"
    else return $ nextKey $ T.pack (fromSql (last res !! 1) :: String)

-- Constructing a pair from a row of sql values
_constructPair :: [SqlValue] -> (T.Text, T.Text)
_constructPair (_:shurl:url:[]) =
  (T.pack (fromSql shurl :: String), T.pack (fromSql url :: String))

-- Getting every (shurl, url) pair
_getAll :: IO [(T.Text, T.Text)]
_getAll = do
  db <- _dbConnection
  res <- quickQuery' db ("SELECT * FROM redirects") []

  return $ map (_constructPair) res

-- Getting a (shurl, url) pair from the database
_getPair :: T.Text -> IO (Maybe (T.Text, T.Text))
_getPair shurl = do
  db <- _dbConnection
  res <- quickQuery' db ("SELECT * FROM redirects WHERE shurl==" ++ show shurl) []
  commit db

  if res == []
    then return Nothing
    else return $ Just $ _constructPair $ head res

-- Getting a url
getUrl :: T.Text -> IO (Maybe T.Text)
getUrl shurl = _getPair shurl >>= return . liftM snd

-- Inserting a (shurl, url) pair into the database
putUrl :: T.Text -> IO T.Text
putUrl url = do
  db <- _dbConnection
  shurl <- _nextKey
  pair <- _getPair shurl

  case pair of
    Nothing -> do
      quickQuery' db ("INSERT INTO redirects(shurl, url) values(" ++ show shurl ++ ", " ++ show url ++ ")") []
      commit db
      return shurl
    Just _ ->
      return shurl