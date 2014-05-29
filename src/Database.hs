{-# LANGUAGE OverloadedStrings #-}

module Database (getUrl, putUrl) where

import qualified Data.Text.Lazy as T
import Data.List (sort)
import Data.Char

import Database.HDBC.Sqlite3
import Database.HDBC

import System.Directory

import Control.Monad

import KeyGenerator

-- The database connection
_dbConnection :: IO Connection
_dbConnection = do
  fe <- doesFileExist "./redirects.db"
  db <- connectSqlite3 "./redirects.db"

  if not fe
    then do
      quickQuery' db "CREATE TABLE redirects (rowid INTEGER PRIMARY KEY AUTOINCREMENT, shurl VARCHAR, url VARCHAR)" []
      commit db

      return db
    else return db

-- Getting the next key from the database
_nextKey :: IO T.Text
_nextKey = do
  db <- _dbConnection
  res <- quickQuery' db "SELECT * FROM redirects" []
  commit db

  return $ if null res
    then "a"
    else nextKey $ T.pack (fromSql (last res !! 1) :: String)

-- Constructing a pair from a row of sql values
_constructPair :: [SqlValue] -> (T.Text, T.Text)
_constructPair (_:shurl:url:[]) =
  (T.pack (fromSql shurl :: String), T.pack (fromSql url :: String))

-- Getting every (shurl, url) pair
_getAll :: IO [(T.Text, T.Text)]
_getAll = do
  db <- _dbConnection
  res <- quickQuery' db "SELECT * FROM redirects" []

  return $ map _constructPair res

-- Getting a (shurl, url) pair from the database
_getPair :: T.Text -> IO (Maybe (T.Text, T.Text))
_getPair shurl = do
  db <- _dbConnection
  res <- quickQuery' db ("SELECT * FROM redirects WHERE shurl==" ++ show shurl) []
  commit db

  return $ if null res
    then Nothing
    else Just $ _constructPair $ head res

-- Getting a url
getUrl :: T.Text -> IO (Maybe T.Text)
getUrl shurl = liftM (liftM snd) $ _getPair shurl

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