{-# LANGUAGE OverloadedStrings #-}

module Templates.ErrorPage where

-------------
-- Imports --
import Text.Blaze.Html.Renderer.Text as R
import Text.Blaze.Html5.Attributes as A
import Text.Blaze.Html5 as T

import Data.Text.Lazy hiding (head)

import Prelude hiding (head, div)

import Templates.Template
import Templates.Header

----------
-- Code --
data ErrorPage = ErrorPage

instance Template ErrorPage where
  makeHtml _ =
    makeHtml $ Header "errorpage" $ do
      h1 ! class_ "text-center" $ do
        "Error: 404"
        br
        small "Page not found."