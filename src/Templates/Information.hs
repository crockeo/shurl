{-# LANGUAGE OverloadedStrings #-}

module Templates.Information where

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
data Information = Information

instance Template Information where
  makeHtml _ =
    makeHtml $ Header "information" area