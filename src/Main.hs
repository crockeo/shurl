{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Scotty

import Templates.Template
import Templates.Index
import Templates.Information
import Templates.ErrorPage

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
  indexRoute
  informationRoute
  errorRoute