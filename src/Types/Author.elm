module Types.Author exposing (..)

import OptimizedDecoder as OD


type alias Author =
    { id : String
    , name : String
    , image : String
    , introduction : String
    }


authorDecoder : OD.Decoder Author
authorDecoder =
    OD.map4 Author
        (OD.field "id" OD.string)
        (OD.field "name" OD.string)
        (OD.field "image" (OD.field "url" OD.string))
        (OD.field "introduction" OD.string)
