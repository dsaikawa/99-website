module Components.NavBar exposing (..)

import Css exposing (absolute, fontSize, int, position, px, relative, width, zIndex)
import Html.Styled exposing (a, button, div, img, nav, text)
import Html.Styled.Attributes exposing (class, css, href, src, type_)
import Html.Styled.Events exposing (onClick)
import Style.FontFamily exposing (logoFontFamily)
import Utils.BrandName as BrandName



{- トップページで使用するナビゲーションバー -}


topPageNavBarView : msg -> Html.Styled.Html msg
topPageNavBarView msg =
    navBarView_ "position-absolute" "text-light" "/icon/list.svg" msg



{- トップページ以外で使用するナビゲーションバー -}


navBarView : msg -> Html.Styled.Html msg
navBarView msg =
    navBarView_ "border-bottom border-2 border-dark" "text-dark" "/icon/list-dark.svg" msg



{- ナビゲーションバーのコンポーネント

   以下の三つの項目を引数にとる

   - navClassOption : トップページで画像に重ねるため必要
   - textColor : ロゴのカラー(現状 bootstrap が用意している class の色だけ)
   - iconSrc : 使用する icon のパス

-}


navBarView_ : String -> String -> String -> msg -> Html.Styled.Html msg
navBarView_ navClassOption textColor iconSrc msg =
    nav
        [ class <| "navbar w-100 " ++ navClassOption
        , css [ zIndex <| int 1 ]
        ]
        [ div [ class "container-fluid" ]
            [ a
                [ logoFontFamily
                , css [ fontSize <| px 38 ]
                , class <| "text-decoration-none " ++ textColor
                , href "/"
                ]
                [ text BrandName.brandName ]
            , button
                [ class "ms-auto btn"
                , type_ "button"
                , onClick msg
                ]
                [ img
                    [ css
                        [ width <| px 40 ]
                    , src iconSrc
                    ]
                    []
                ]
            ]
        ]
