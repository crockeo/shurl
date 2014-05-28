{-# LANGUAGE OverloadedStrings #-}

module Main where

import Network.Wai.Middleware.Static
import Network.CGI (liftIO)
import Web.Scotty

import Data.Text.Lazy

import Templates.Template
import Templates.Index
import Templates.NewPage
import Templates.Information
import Templates.ErrorPage

import Database

-- Serving static content
staticRoute :: ScottyM ()
staticRoute =
  middleware $ staticPolicy (noDots >-> addBase "static")

-- Serving the index page
indexRoute :: ScottyM ()
indexRoute =
  get "/" $ do
    url <- (param "url" :: ActionM Text) `rescue` (\x -> return "")

    if url == ""
      then render Index
      else do
        key <- liftIO nextKey
        liftIO $ putUrl (key, url)

        redirect $ "/np/" `append` key

-- Serving the new redirect page
newPageRoute   :: ScottyM ()
newPageRoute =
  get "/np/:key" $ do
    key <- param "key"
    render $ NewPage key

-- Either redirecting or serving
-- the no-redirect page
redirectRoute :: ScottyM ()
redirectRoute =
  get "/r/:key" $ do
    redir <- param "key" >>= liftIO . getUrl

    case redir of
      Nothing   -> render ErrorPage
      Just    k -> redirect k

-- Serving the information page
informationRoute :: ScottyM ()
informationRoute =
  get "/information" $ render Information

-- Serving the error 404 page
errorRoute :: ScottyM ()
errorRoute =
  notFound $ render ErrorPage

main :: IO ()
main =
  scotty 80 $ do
    staticRoute
    indexRoute
    newPageRoute
    redirectRoute
    informationRoute
    errorRoute