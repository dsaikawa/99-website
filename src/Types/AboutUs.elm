module Types.AboutUs exposing (..)

import OptimizedDecoder as OD


type alias AboutUs =
    { title : String
    , thumbnail : String
    }


aboutUsDecoder : OD.Decoder AboutUs
aboutUsDecoder =
    OD.map2 AboutUs
        (OD.field "title" OD.string)
        (OD.field "thumbnail" (OD.field "url" OD.string))


type alias AboutUsContent =
    { title : String
    , content : String
    , eyecatch : String
    , thumbnail : String
    }


aboutUsContentDecoder : OD.Decoder AboutUsContent
aboutUsContentDecoder =
    OD.map4 AboutUsContent
        (OD.field "title" OD.string)
        (OD.field "content" OD.string)
        (OD.field "eyecatch" (OD.field "url" OD.string))
        (OD.field "thumbnail" (OD.field "url" OD.string))
