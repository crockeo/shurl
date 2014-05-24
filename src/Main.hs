{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Scotty

main :: IO ()
main = scotty 80 $ do
  notFound $
    html "<h1>This is just the first commit, folks</h1>"