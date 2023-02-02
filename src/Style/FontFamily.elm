module Style.FontFamily exposing (..)

import Css exposing (fontFamilies)
import Html.Styled
import Svg.Styled.Attributes exposing (css)


logoFontFamily : Html.Styled.Attribute msg
logoFontFamily =
    css [ fontFamilies [ "Bangers" ] ]
