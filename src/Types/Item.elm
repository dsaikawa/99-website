module Types.Item exposing (..)

import OptimizedDecoder as OD


type alias ItemData =
    { itemName : String
    , itemLink : String
    , itemImageLink : String
    , itemPrice : String
    }


itemDataDecoder : OD.Decoder ItemData
itemDataDecoder =
    OD.map4 ItemData
        (OD.field "itemName" OD.string)
        (OD.field "itemLink" OD.string)
        (OD.field "itemImageLink" OD.string)
        (OD.field "itemPrice" OD.string)
