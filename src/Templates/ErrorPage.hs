{-# LANGUAGE OverloadedStrings #-}

module Templates.ErrorPage where

-------------
-- Imports --
import Text.Blaze.Html.Renderer.Text
import Text.Blaze.Html5.Attributes
import Text.Blaze.Html5

import Data.Text.Lazy hiding (head)

import Prelude hiding (head, div)

import Templates.Template
import Templates.Header

----------
-- Code --
data ErrorPage = ErrorPage

instance Template ErrorPage where
  makeHtml _ =
    makeHtml $ Header "index" area