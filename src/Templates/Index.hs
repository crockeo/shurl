{-# LANGUAGE OverloadedStrings #-}

module Templates.Index where

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
data Index = Index

instance Template Index where
  makeHtml _ =
    makeHtml $ Header "index" area