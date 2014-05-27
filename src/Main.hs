{-# LANGUAGE OverloadedStrings #-}

module Main where

import Network.Wai.Middleware.Static
import Web.Scotty

import Templates.Template
import Templates.Index
import Templates.Information
import Templates.ErrorPage

staticRoute :: ScottyM ()
staticRoute =
  middleware $ staticPolicy (noDots >-> addBase "static")

indexRoute :: ScottyM ()
indexRoute =
  get "/" $ render Index

informationRoute :: ScottyM ()
informationRoute =
  get "/information" $ render Information

errorRoute :: ScottyM ()
errorRoute =
  notFound $ render ErrorPage

main :: IO ()
main = scotty 80 $ do
  staticRoute
  indexRoute
  informationRoute
  errorRoute