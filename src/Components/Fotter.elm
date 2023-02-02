module Components.Fotter exposing (..)

import Css exposing (fontSize, px)
import Html
import Html.Styled exposing (a, div, text)
import Html.Styled.Attributes exposing (class, css, href)
import Style.FontFamily exposing (logoFontFamily)
import Types.Shop exposing (shopLink)


footer : Html.Html msg
footer =
    Html.Styled.toUnstyled styledFooter


styledFooter : Html.Styled.Html msg
styledFooter =
    div [ class "mt-3" ]
        [ div [ class "bg-black" ]
            [ div [ class "container-fluid p-4" ]
                [ div [ class "row" ]
                    [ div [ class "d-grid gap-2 d-md-block" ]
                        [ a [ css [ fontSize <| px 40 ], logoFontFamily, class "text-decoration-none text-light text-center", href "/" ] [ text "99 Paradise wood" ] ]
                    , div [ class "d-grid d-md-block justify-content-md-end" ]
                        [ a_ "About us" "/about-us"
                        , a_ "Home" "/"
                        , a_ "Story" "/stories"
                        , a_ "Shop" shopLink
                        ]
                    ]
                ]
            ]
        ]


a_ title link =
    a [ css [ fontSize <| px 35 ], logoFontFamily, class "text-decoration-none text-light me-md-4 text-center", href link ] [ text title ]
