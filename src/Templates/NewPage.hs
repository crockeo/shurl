{-# LANGUAGE OverloadedStrings #-}

module Templates.NewPage where

-------------
-- Imports --
import Text.Blaze.Html.Renderer.Text
import Text.Blaze.Html5.Attributes
import Text.Blaze.Html5

import Data.Text.Lazy hiding (head)
import Data.String

import Prelude hiding (head, div)

import Templates.Template
import Templates.Header

----------
-- Code --
data NewPage = NewPage Text

instance Template NewPage where
  makeHtml (NewPage str) =
    makeHtml $ Header "newpage" $ do
      h1 ! class_ "text-center" $ "New link created at:"
      h2 ! class_ "text-center" $ a ! (href $ fromString ("/" ++ unpack str)) $ fromString ("http://shurl.com/" ++ unpack str)