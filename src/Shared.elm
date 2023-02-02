module Shared exposing (Data, Model, Msg(..), SharedMsg(..), template)

import Browser.Navigation
import Components.Fotter exposing (a_, footer)
import Components.NavBar exposing (navBarView, topPageNavBarView)
import Css exposing (backgroundColor, fixed, fontSize, hex, hidden, int, num, opacity, overflow, pct, px, top, width, zIndex)
import DataSource
import Html exposing (Html, node)
import Html.Attributes exposing (attribute, href, rel)
import Html.Styled exposing (a, button, div, img, text, toUnstyled)
import Html.Styled.Attributes exposing (class, src, type_)
import Html.Styled.Events exposing (onClick)
import Pages.Flags
import Pages.PageUrl exposing (PageUrl)
import Path exposing (Path)
import Route exposing (Route)
import SharedTemplate exposing (SharedTemplate)
import Style.FontFamily exposing (logoFontFamily)
import Svg.Styled.Attributes exposing (css)
import Types.Shop exposing (shopLink)
import View exposing (View)


template : SharedTemplate Msg Model Data msg
template =
    { init = init
    , update = update
    , view = view
    , data = data
    , subscriptions = subscriptions
    , onPageChange = Just OnPageChange
    }


type Msg
    = OnPageChange
        { path : Path
        , query : Maybe String
        , fragment : Maybe String
        }
    | SharedMsg SharedMsg


type alias Data =
    ()


type SharedMsg
    = ClickedHamburger


type alias Model =
    { showMobileMenu : Bool
    , showSideBar : Bool
    }


init :
    Maybe Browser.Navigation.Key
    -> Pages.Flags.Flags
    ->
        Maybe
            { path :
                { path : Path
                , query : Maybe String
                , fragment : Maybe String
                }
            , metadata : route
            , pageUrl : Maybe PageUrl
            }
    -> ( Model, Cmd Msg )
init navigationKey flags maybePagePath =
    ( { showMobileMenu = False, showSideBar = False }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnPageChange _ ->
            ( { model | showMobileMenu = False, showSideBar = False }, Cmd.none )

        SharedMsg globalMsg ->
            case globalMsg of
                ClickedHamburger ->
                    ( { model | showSideBar = not model.showSideBar }, Cmd.none )


subscriptions : Path -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none


data : DataSource.DataSource Data
data =
    DataSource.succeed ()


view :
    Data
    ->
        { path : Path
        , route : Maybe Route
        }
    -> Model
    -> (Msg -> msg)
    -> View msg
    -> { body : Html msg, title : String }
view sharedData page model toMsg pageView =
    let
        navBar =
            case Path.toRelative page.path of
                "" ->
                    toUnstyled <| topPageNavBarView (toMsg <| SharedMsg ClickedHamburger)

                _ ->
                    toUnstyled <| navBarView (toMsg <| SharedMsg ClickedHamburger)
    in
    { body =
        Html.div []
            (googleFontCDN
                ++ [ bootstrapCDN, sideBar model.showSideBar (toMsg <| SharedMsg ClickedHamburger), navBar ]
                ++ pageView.body
                ++ [ footer ]
            )
    , title = pageView.title
    }


bootstrapCDN : Html msg
bootstrapCDN =
    node "link"
        [ rel "stylesheet"
        , href "https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css"
        , attribute "integrity" "sha384-GLhlTQ8iRABdZLl6O3oVMWSktQOp6b7In1Zl3/Jr59b6EGGoI1aFkw7cmDA6j6gD"
        , attribute "crossorigin" "anonymous"
        ]
        []


googleFontCDN : List (Html msg)
googleFontCDN =
    [ node "link" [ rel "preconnect", href "https://fonts.googleapis.com" ] []
    , node "link" [ rel "preconnect", href "https://fonts.gstatic.com", attribute "crossorigin" "anonymous" ] []
    , node "link" [ rel "stylesheet", href "https://fonts.googleapis.com/css2?family=Bangers&display=swap" ] []
    ]


sideBar : Bool -> msg -> Html.Html msg
sideBar showSideBar msg =
    toUnstyled <|
        if showSideBar then
            div []
                [ div
                    [ class "vh-100 vw-100 fixed-top"
                    , css
                        [ zIndex (int 10)
                        , opacity <| num 0.9
                        , backgroundColor <| hex "000000"
                        ]
                    ]
                    [ div [ class "w-100 d-grid d-flex justify-content-end" ]
                        [ button
                            [ class "btn ms-auto"
                            , type_ "button"
                            , onClick msg
                            ]
                            [ img
                                [ css
                                    [ width <| px 50
                                    , zIndex (int 11)
                                    ]
                                , src "/icon/x.svg"
                                ]
                                []
                            ]
                        ]
                    , div [ class "d-flex" ]
                        [ div [ class "container-fluid p-4" ]
                            [ div [ class "row" ]
                                [ div [ class "d-grid gap-2 d-block" ]
                                    [ a
                                        [ logoFontFamily
                                        , css [ fontSize <| px 40 ]
                                        , class "text-decoration-none text-light text-center"
                                        , Html.Styled.Attributes.href "/"
                                        ]
                                        [ text "99 Paradise wood" ]
                                    ]
                                , div [ class "d-grid d-block justify-content-center" ]
                                    [ a_ "About us" "/about-us"
                                    , a_ "Home" "/"
                                    , a_ "Story" "/stories"
                                    , a_ "Shop" shopLink
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]

        else
            div [] []
