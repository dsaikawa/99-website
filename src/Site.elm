module Site exposing (config)

import DataSource
import Head
import LanguageTag
import LanguageTag.Language
import Pages.Manifest as Manifest
import Pages.Url
import Route
import SiteConfig exposing (SiteConfig)


type alias Data =
    ()


config : SiteConfig Data
config =
    { data = data
    , canonicalUrl = "https://elm-pages.com"
    , manifest = manifest
    , head = head
    }


data : DataSource.DataSource Data
data =
    DataSource.succeed ()


head : Data -> List Head.Tag
head static =
    [ Head.sitemapLink "/sitemap.xml"
    , Head.rootLanguage <| LanguageTag.build LanguageTag.emptySubtags <| LanguageTag.Language.ja
    ]


manifest : Data -> Manifest.Config
manifest static =
    Manifest.init
        { name = "99"
        , description = "Description"
        , startUrl = Route.Index |> Route.toPath
        , icons =
            [ getIcon "icon/icon-192x192.png" 192
            , getIcon "icon/icon-192x192.png" 256
            , getIcon "icon/icon-192x192.png" 384
            , getIcon "icon/icon-192x192.png" 512
            ]
        }


getIcon : String -> Int -> Manifest.Icon
getIcon path size =
    Manifest.Icon (Pages.Url.external path) [ ( size, size ) ] Nothing []
