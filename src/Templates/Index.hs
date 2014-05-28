{-# LANGUAGE OverloadedStrings #-}

module Templates.Index where

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
data Index = Index

instance Template Index where
  makeHtml _ =
    makeHtml $ Header "index" $
      div ! class_ "container" $ do
        h4 ! class_ "text-justify col-md-4 col-md-offset-4" $ toHtml $
          "Enter a url below to recieve a shortened version. Copy " `append`
          "the resulting URL to post on forums, send to friends, or " `append`
          "post it on Facebook!"

        T.form ! class_ "form-horizontal col-md-8 col-md-offset-2" $ do
          div ! class_ "form-group" $ do
            T.label ! class_ "control-label" $ h2 "URL"
            input   ! type_ "text"   ! name "url" ! placeholder "Enter URL" ! class_ "form-control input-lg"

          div ! class_ "form-group" $
            input ! type_ "submit" ! class_ "btn btn-default"