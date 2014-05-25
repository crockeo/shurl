{-# LANGUAGE OverloadedStrings #-}

module Templates.Template where

-------------
-- Imports --
import Text.Blaze.Html.Renderer.Text
import Text.Blaze.Html5.Attributes
import Text.Blaze.Html5

import Data.Text.Lazy hiding (head)

import Prelude hiding (head, div)

import Web.Scotty

----------
-- Code --
class Template a where
  makeHtml :: a -> Html

  makeText :: a -> Text
  makeText = renderHtml . makeHtml

  render :: a -> ActionM ()
  render = Web.Scotty.html . makeText