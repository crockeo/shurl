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
        h1 ! class_ "col-md-offset-1" $ strong "New URL:"
        
        T.form ! class_ "form-inline col-md-offset-2" $ do
          div ! class_ "form-group col-md-3" $
            input ! type_ "text"   ! name "url" ! placeholder "Enter URL" ! class_ "form-control"

          div ! class_ "form-group" $
            input ! type_ "submit"                                        ! class_ "btn btn-default"