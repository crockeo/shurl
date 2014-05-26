{-# LANGUAGE OverloadedStrings #-}

module Templates.Header where

-------------
-- Imports --
import Text.Blaze.Html.Renderer.Text
import Text.Blaze.Html5.Attributes
import Text.Blaze.Html5

import Data.Text.Lazy hiding (head)
import Data.String hiding (append)

import Prelude hiding (head, div)

import Templates.Template

----------
-- Code --
data Header = Header Text Html

-- The head section
_head :: Text -> Html
_head name =
  head $ do
   link ! rel "stylesheet" ! href "http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css"
   link ! rel "stylesheet" ! href "http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css"

   script "" ! type_ "application/javascript" ! (src  $ fromString $ unpack ("/js/"  `append` name `append` ".js" ))
   link      ! rel   "stylesheet"             ! (href $ fromString $ unpack ("/css/" `append` name `append` ".css"))
   link      ! rel   "stylesheet"             ! (href "/css/main.css"                                              )

-- The header row
_toprow :: Html
_toprow =
  div ! class_ "row toprow" $ do
    h1 $ a "shurl"       ! href "/"            ! class_ "col-md-2 col-md-offset-1"
    h1 $ a "information" ! href "/information" ! class_ "col-md-2"

-- The body section
_body :: Html -> Html
_body html =
  body $ do
    div ! class_ "container-fluid" $ do
      _toprow
      html

instance Template Header where
  makeHtml (Header name html) =
    docTypeHtml $ do
      _head name
      _body html