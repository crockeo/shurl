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
    makeHtml $ Header "information" $ do
      div ! class_ "row" $ do
        h3 ! class_ "col-md-2 col-md-offset-2 text-right" $ "Author:"
        h3 ! class_ "col-md-6" $ "Crockeo"

      div ! class_ "row" $ do
        h3 ! class_ "col-md-2 col-md-offset-2 text-right" $ "Email:"
        h3 ! class_ "col-md-6" $ a ! href "mailto:crockeo@gmail.com" $ "crockeo@gmail.com"

      div ! class_ "row" $ do
        h3 ! class_ "col-md-2 col-md-offset-2 text-right" $ "Description:"
        p ! class_ "col-md-6" $ toHtml $ "shurl is a learning-project written by Cerek "         `append`
                                         "'Crockeo' Hillen to learn how to use Scotty and "      `append`
                                         "Blaze-Html to make web applications.\n\nIt is a "      `append`
                                         "fully functional url-shortener. That is, you input a " `append`
                                         "longer URL, and shurl gives you a shorter URL that "   `append`
                                         "will redirect you to the original URL."