module Utils.Metadata exposing (..)


locale : Maybe String
locale =
    Just "ja_JP"


siteName : String
siteName =
    "99 Paradise wood - Corporate site"


title : String -> String
title page =
    "99 Paradise wood - " ++ page
