module Types.Story exposing (..)

import OptimizedDecoder as OD
import Types.Author exposing (Author, authorDecoder)


type alias Story =
    { title : String
    , id : String
    , thumbnailUrl : String
    }


storyDecoder : OD.Decoder Story
storyDecoder =
    OD.map3 Story
        (OD.field "title" OD.string)
        (OD.field "id" OD.string)
        (OD.field "thumbnail" (OD.field "url" OD.string))


type alias StoryContent =
    { id : String
    , createdAt : String
    , title : String
    , content : String
    , eyecatch : String
    , thumbnail : String
    , author : Author
    }


storyContentDecoder : OD.Decoder StoryContent
storyContentDecoder =
    OD.map7 StoryContent
        (OD.field "id" OD.string)
        (OD.field "createdAt" OD.string)
        (OD.field "title" OD.string)
        (OD.field "content" OD.string)
        (OD.field "eyecatch" (OD.field "url" OD.string))
        (OD.field "thumbnail" (OD.field "url" OD.string))
        (OD.field "author" authorDecoder)
