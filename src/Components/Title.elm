module Components.Title exposing (..)

import Css exposing (fixed, fontSize, px, tableLayout)
import Html.Styled exposing (a, div, text)
import Html.Styled.Attributes exposing (class, css, href)
import Style.FontFamily exposing (logoFontFamily)



{- 各エリアタイトル用の View

   contentTitle "Story" "#"
-}


contentTitle : String -> String -> Html.Styled.Html msg
contentTitle title ariaHref =
    contentTitle_ title ariaHref True



{-
   すべて表示を表示しない場合は isDisplay に False 渡す
-}


contentTitle_ : String -> String -> Bool -> Html.Styled.Html msg
contentTitle_ title ariaHref isDisplayAll =
    div [ class "container d-flex" ]
        (a [ css [ fontSize <| px 40, tableLayout fixed ], logoFontFamily, class "text-dark text-decoration-none", href ariaHref ] [ text title ]
            :: (if isDisplayAll then
                    [ a [ class "fw-semibold text-black align-self-center ms-2", href ariaHref ] [ text "すべて表示" ] ]

                else
                    []
               )
        )


justTitle : String -> Html.Styled.Html msg
justTitle title =
    div [ css [ fontSize <| px 40, tableLayout fixed ], logoFontFamily, class "text-dark text-decoration-none" ] [ text title ]
