module Page.Index exposing (Data, Model, Msg, page)

import Components.Box exposing (boxView, boxView_)
import Components.Title exposing (contentTitle)
import DataSource as DataSource exposing (DataSource)
import DataSource.Port
import Head
import Head.Seo as Seo
import Html.Styled exposing (div, img, toUnstyled)
import Html.Styled.Attributes exposing (class, src)
import Json.Encode
import List exposing (map)
import OptimizedDecoder as OD
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Types.Item exposing (ItemData)
import Types.Shop exposing (shopLink)
import Types.Story exposing (Story)
import Utils.MicroCMS as MicroCMS exposing (getItems, getStories)
import Utils.Price exposing (addYen)
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


data : DataSource Data
data =
    DataSource.map2
        Data
        (DataSource.Port.get "environmentVariable" (Json.Encode.string MicroCMS.itemEnvName) OD.string
            |> DataSource.andThen
                (\env -> getItems env)
        )
        (DataSource.Port.get "environmentVariable" (Json.Encode.string MicroCMS.storyEnvName) OD.string
            |> DataSource.andThen
                (\env -> getStories env [ "thumbnail", "title", "id" ])
        )


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "TODO title" -- metadata.title -- TODO
        }
        |> Seo.website


type alias Data =
    { itemDatas : List ItemData
    , blogs : List Story
    }


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = "HOGE", body = [ toUnstyled <| styledView static.data ] }


styledView : Data -> Html.Styled.Html msg
styledView staticData =
    div []
        [ img
            [ src "/image/top.JPG"
            , class "vh-100 vw-100 object-fit-cover position-relative"
            ]
            []
        , div [ class "" ]
            [ itemView staticData, storyView staticData ]
        ]


itemView : Data -> Html.Styled.Html msg
itemView staticData =
    div []
        [ div [ class "mt-3" ] [ contentTitle "Item" shopLink ]
        , div [ class "container" ]
            [ div [ class "row" ]
                (map
                    (\datas ->
                        boxView_ datas.itemImageLink
                            datas.itemName
                            (Just <| addYen datas.itemPrice)
                            "col-xl-4 col-lg-6 col-12  mt-3"
                            datas.itemLink
                    )
                    staticData.itemDatas
                )
            ]
        ]



{- Story を表示するエリアの View -}


storyView : Data -> Html.Styled.Html msg
storyView staticData =
    div []
        [ div [ class "mt-3" ] [ contentTitle "Story" "/stories" ]
        , div [ class "container" ]
            [ div [ class "row" ]
                (map (\blog -> boxView blog.thumbnailUrl blog.title "col-xl-4 col-lg-6 col-12 mt-3" ("/stories/" ++ blog.id)) staticData.blogs)
            ]
        ]
