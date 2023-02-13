module Page.Stories.Id_ exposing (Data, Model, Msg, page)

import Components.Box exposing (boxView, boxView_)
import Components.Title exposing (contentTitle, contentTitle_, justTitle)
import Css exposing (absolute, auto, border, border2, borderBottom, borderBottom2, borderLeft2, borderRadius2, borderRadius4, borderRight2, borderTop, borderTop2, dashed, em, margin, margin2, marginBottom, marginTop, middle, pct, position, px, solid, static, top, verticalAlign)
import Css.Media exposing (maxWidth, minWidth, only, screen, withMedia)
import DataSource exposing (DataSource)
import DataSource.Port
import Head
import Head.Seo as Seo
import Html
import Html.Styled exposing (div, fromUnstyled, img, span, styled, text, toUnstyled)
import Html.Styled.Attributes exposing (class, css, src)
import Json.Encode
import List
import Markdown exposing (defaultOptions)
import OptimizedDecoder as OD
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Types.AboutUs exposing (AboutUs, aboutUsDecoder)
import Types.Author exposing (Author)
import Types.Item exposing (ItemData)
import Types.Shop exposing (shopLink)
import Types.Story exposing (StoryContent)
import Utils.Metadata exposing (locale, siteName, title)
import Utils.MicroCMS as MicroCMS exposing (getAboutUs, getItems, getStories, getStoryById)
import Utils.Price exposing (addYen)
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    { id : String }


page : Page RouteParams Data
page =
    Page.prerender
        { head = head
        , routes = routes
        , data = data
        }
        |> Page.buildNoState { view = view }


routes : DataSource (List RouteParams)
routes =
    let
        blogIds =
            DataSource.Port.get "environmentVariable" (Json.Encode.string MicroCMS.storyEnvName) OD.string
                |> DataSource.andThen
                    (\env ->
                        getStories env [ "thumbnail", "title", "id" ]
                    )

        routeParams =
            DataSource.map
                (\blogs ->
                    List.map
                        (\blog ->
                            { id = blog.id }
                        )
                        blogs
                )
                blogIds
    in
    routeParams


data : RouteParams -> DataSource Data
data routeParams =
    DataSource.map3 Data
        (DataSource.Port.get "environmentVariable" (Json.Encode.string MicroCMS.storyEnvName) OD.string
            |> DataSource.andThen
                (\env -> getStoryById env routeParams.id [])
        )
        (DataSource.Port.get "environmentVariable" (Json.Encode.string MicroCMS.itemEnvName) OD.string
            |> DataSource.andThen
                (\env -> getAboutUs env [ "title", "thumbnail" ] aboutUsDecoder)
        )
        (DataSource.Port.get "environmentVariable" (Json.Encode.string MicroCMS.itemEnvName) OD.string
            |> DataSource.andThen
                (\env -> getItems env)
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
        , description =
            "\"99 Paradise wood\" というアパレルブランドの私たちの生活についてのページです。このページは「"
                ++ static.data.storyContent.title
                ++ "」についてのページです。"
        , locale = locale
        , title = title static.data.storyContent.title
        }
        |> Seo.website


type alias Data =
    { storyContent : StoryContent
    , aboutUs : AboutUs
    , itemDatas : List ItemData
    }


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = title static.data.storyContent.title, body = [ toUnstyled <| styledView static.data ] }


styledView : Data -> Html.Styled.Html msg
styledView staticData =
    div [ class "container" ]
        [ div [ class "row" ]
            [ div [ class "col-lg-8" ] [ storyContentView staticData ]
            , div [ class "col-lg-4" ] [ sideBarView staticData ]
            , div [ class "col-lg-8 offset-lg-2" ] [ atuhorView staticData ]
            ]
        ]


storyContentView : Data -> Html.Styled.Html msg
storyContentView staticData =
    div [ class "mt-3" ]
        [ div [ class "fs-1 fw-bold" ] [ text staticData.storyContent.title ]
        , img [ class "w-100 mt-3 border border-dark rounded-4", src staticData.storyContent.eyecatch ] []
        , div [ class "mt-4 fs-4" ] [ fromUnstyled <| storyContentBody staticData.storyContent.content ]
        ]


storyContentBody : String -> Html.Html msg
storyContentBody content =
    Markdown.toHtmlWith
        { defaultOptions
            | sanitize = False
        }
        []
        content


sideBarView : Data -> Html.Styled.Html msg
sideBarView staticData =
    let
        mItem : Maybe ItemData
        mItem =
            List.head staticData.itemDatas
    in
    div []
        ([ div [] [ contentTitle_ "About us" "/about-us" False ]
         , boxView staticData.aboutUs.thumbnail staticData.aboutUs.title "" "/about-us"
         ]
            ++ (case mItem of
                    Just item ->
                        [ div [] [ contentTitle "Item" shopLink ]
                        , boxView_ item.itemImageLink item.itemName (Just (addYen item.itemPrice)) "" item.itemLink
                        ]

                    Nothing ->
                        []
               )
        )


atuhorView : Data -> Html.Styled.Html msg
atuhorView staticData =
    let
        author =
            staticData.storyContent.author

        name =
            author.name

        image =
            author.image

        introduction =
            author.introduction
    in
    div [ class "container mt-md-4" ]
        [ div [] [ justTitle "Author" ]
        , div [ class "row border border-dark rounded-4" ]
            [ div [ class "col-md-6 px-0" ]
                [ img
                    [ css
                        [ borderRadius4 (em 0.9) (em 0) (em 0) (em 0.9)
                        , withMedia [ only screen [ maxWidth <| px 767 ] ]
                            [ borderRadius4 (em 0.9) (em 0.9) (em 0) (em 0)
                            ]
                        ]
                    , src image
                    , class "w-100"
                    ]
                    []
                ]
            , div
                [ class "my-3 col-md-6" ]
                [ div [ class "h-100 w-100" ]
                    [ div [ class "fw-bold align-middle fs-4" ] [ text name ]
                    , div [ class "mt-3" ] [ text introduction ]
                    ]
                ]
            ]
        ]
