module Components.Box exposing (..)

import Css exposing (absolute, block, display, fixed, height, left, maxWidth, pct, position, px, relative, tableLayout, top, width)
import Html.Styled exposing (a, div, img, text)
import Html.Styled.Attributes exposing (class, css, href, src)


boxView : String -> String -> String -> String -> Html.Styled.Html msg
boxView imageSrc title classOption boxHref =
    boxView_ imageSrc title Nothing classOption boxHref


boxView_ : String -> String -> Maybe String -> String -> String -> Html.Styled.Html msg
boxView_ imageSrc title mPrice classOption boxHref =
    div [ class classOption ]
        [ div [ class "border border-dark rounded-3", css [ position relative ] ]
            ([ img [ css [ maxWidth <| pct 100 ], class "rounded-t-xl w-full object-fit-cover rounded-top-2", src imageSrc ] []
             , div [ css [ tableLayout fixed, height <| px 40 ], class "pt-3 px-3 fw-bold w-full break-words h-3" ]
                [ text title
                ]
             , a [ href boxHref, css [ display block, position absolute, top <| px 0, left <| px 0, width <| pct 100, height <| pct 100 ] ] []
             ]
                ++ (case mPrice of
                        Just price ->
                            [ div [ css [ tableLayout fixed, height <| px 40 ], class "pb-3 px-3 fw-bold w-full break-words h-2" ]
                                [ text price
                                ]
                            ]

                        Nothing ->
                            [ div [ css [ tableLayout fixed, height <| px 40 ], class "pb-3 px-3 fw-bold w-full break-words h-2" ]
                                [ text ""
                                ]
                            ]
                   )
            )
        ]
