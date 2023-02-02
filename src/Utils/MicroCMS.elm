module Utils.MicroCMS exposing (..)

import DataSource as DataSource exposing (DataSource)
import DataSource.Http as DSHttp
import OptimizedDecoder as OD
import Pages.Secrets as Secrets
import String exposing (join)
import Types.AboutUs exposing (aboutUsDecoder)
import Types.Item exposing (ItemData, itemDataDecoder)
import Types.Story exposing (Story, StoryContent, storyContentDecoder, storyDecoder)


microCmsRequest : String -> String -> String -> String -> OD.Decoder a -> DataSource a
microCmsRequest url query method header decoder =
    DSHttp.request
        (Secrets.succeed
            { url = url ++ query
            , method = method
            , headers = [ ( "X-MICROCMS-API-KEY", header ) ]
            , body = DSHttp.emptyBody
            }
        )
        decoder



{- ブログ取得キーの型 -}


type alias STORY_KEY =
    String



{- 商品取得キーの型 -}


type alias ITEM_KEY =
    String



{- ブログ取得用のキーを保存する環境変数名 -}


storyEnvName : String
storyEnvName =
    "STORY_KEY"



{- 商品情報取得用のキーを保存する環境変数 -}


itemEnvName : String
itemEnvName =
    "ITEM_KEY"



{-
   ブログ情報取得用のエンドポイント
-}


blogsEndpoint : String
blogsEndpoint =
    "https://99paradisewood.microcms.io/api/v1/blogs"



{-
   Item情報取得用のエンドポイント
-}


itemsEndpoint : String
itemsEndpoint =
    "https://99paradisewooditem.microcms.io/api/v1/item"



{-
   About Us 情報取得用のエンドポイント
-}


aboutUsEndpoint : String
aboutUsEndpoint =
    "https://99paradisewooditem.microcms.io/api/v1/about-us"



{-

   クエリパラメーターを作成する関数

   queryFields ["hoge","fuga"] = "?fields=hoge%2Cfuga"

-}


queryFields : List String -> String
queryFields strings =
    "?fields=" ++ join "%2C" strings



{-

   data 取得
   各ページで取得するデータのリクエスト部分

-}
{- トップページに表示するための商品情報取得　 -}


getItems : ITEM_KEY -> DataSource (List ItemData)
getItems itemKey =
    microCmsRequest itemsEndpoint
        "?fields=itemName%2CitemLink%2CitemImageLink%2CitemPrice"
        "GET"
        itemKey
        getItemsDecoder


getItemsDecoder : OD.Decoder (List ItemData)
getItemsDecoder =
    OD.field "contents" (OD.list itemDataDecoder)



{- 　ブログ一覧表示するための情報取得 -}


getStories : STORY_KEY -> List String -> DataSource (List Story)
getStories storyKey querylist =
    microCmsRequest blogsEndpoint
        (queryFields querylist)
        "GET"
        storyKey
        storiesRequestDecoder


storiesRequestDecoder : OD.Decoder (List Story)
storiesRequestDecoder =
    OD.field
        "contents"
        (OD.list storyDecoder)



{-
   ブログの各ページを表示するためのIDによる情報取得
-}


getStoryById : STORY_KEY -> String -> List String -> DataSource StoryContent
getStoryById storyKey id querylist =
    microCmsRequest
        (blogsEndpoint ++ "/" ++ id)
        (queryFields querylist)
        "GET"
        storyKey
        storyContentDecoder


getAboutUs : ITEM_KEY -> List String -> OD.Decoder a -> DataSource a
getAboutUs itemKey querylist decoder =
    microCmsRequest aboutUsEndpoint
        (queryFields querylist)
        "GET"
        itemKey
        decoder
