module Page.Stories exposing (Data, Model, Msg, page)

import Components.Box exposing (boxView)
import Components.Title exposing (contentTitle_)
import DataSource exposing (DataSource)
import DataSource.Port
import Head
import Head.Seo as Seo
import Html.Styled exposing (div, toUnstyled)
import Html.Styled.Attributes exposing (class)
import Json.Encode
import List exposing (map)
import OptimizedDecoder as OD
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Types.Story exposing (Story)
import Utils.Metadata exposing (locale, siteName, title)
import Utils.MicroCMS as MicroCMS exposing (getStories)
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
    { blogs : List Story }


data : DataSource Data
data =
    DataSource.Port.get "environmentVariable" (Json.Encode.string MicroCMS.storyEnvName) OD.string
        |> DataSource.andThen
            (\env ->
                getStories env [ "thumbnail", "title", "id" ]
                    |> DataSource.andThen
                        (\s ->
                            DataSource.succeed { blogs = s }
                        )
            )



-- (DataSource.Port.get "environmentVariable" (Json.Encode.string MicroCMS.storyEnvName) OD.string)
-- (getStories "" [ "thumbnail", "title", "id" ])


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
        , description = "\"99 Paradise wood\" というアパレルブランドのコンセプトや私たちの生活について記載してあるページです。"
        , locale = locale
        , title = title "Stories"
        }
        |> Seo.website


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = title "Stories", body = [ toUnstyled <| storyView static.data ] }


storyView : Data -> Html.Styled.Html msg
storyView staticData =
    div []
        [ div [ class "mt-3" ] [ contentTitle_ "Story" "/stories" False ]
        , div [ class "container" ]
            [ div [ class "row" ]
                (map (\blog -> boxView blog.thumbnailUrl blog.title "col-xl-4 col-lg-6 col-12  mt-3" ("/stories/" ++ blog.id)) staticData.blogs)
            ]
        ]
