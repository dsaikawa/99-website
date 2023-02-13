module Page.AboutUs exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import DataSource.Port
import Head
import Head.Seo as Seo
import Html
import Html.Styled exposing (div, fromUnstyled, img, text, toUnstyled)
import Html.Styled.Attributes exposing (class, src)
import Json.Encode
import Markdown exposing (defaultOptions)
import OptimizedDecoder as OD
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Types.AboutUs exposing (AboutUsContent, aboutUsContentDecoder)
import Utils.Metadata exposing (locale, siteName, title)
import Utils.MicroCMS as MicroCMS exposing (getAboutUs)
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    {}


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


type alias Data =
    { aboutUs : AboutUsContent }


data : DataSource Data
data =
    DataSource.map Data
        (DataSource.Port.get "environmentVariable" (Json.Encode.string MicroCMS.itemEnvName) OD.string
            |> DataSource.andThen
                (\env -> getAboutUs env [] aboutUsContentDecoder)
        )


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = siteName
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "\"99 Paradise wood\" というアパレルブランドのコンセプトや私たちについて記載してあるページです。"
        , locale = locale
        , title = title "About Us"
        }
        |> Seo.website


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = title "About Us", body = [ toUnstyled <| styledView static.data ] }


styledView : Data -> Html.Styled.Html msg
styledView staticData =
    div [ class "container" ]
        [ div [ class "row" ]
            [ aboutUsView staticData.aboutUs
            ]
        ]



{- TODO コンポーネント化する -}


storyContentBody : String -> Html.Html msg
storyContentBody content =
    Markdown.toHtmlWith
        { defaultOptions
            | sanitize = False
        }
        []
        content


aboutUsView aboutUs =
    div [ class "mt-3" ]
        [ div [ class "fs-1 fw-bold" ] [ text aboutUs.title ]
        , img [ class "w-100 mt-3 border border-dark rounded-4", src aboutUs.eyecatch ] []
        , div [ class "mt-4 fs-4" ] [ fromUnstyled <| storyContentBody aboutUs.content ]
        ]
