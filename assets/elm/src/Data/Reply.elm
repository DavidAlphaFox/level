module Data.Reply exposing (Reply, fragment, decoder)

import Date exposing (Date)
import Json.Decode as Decode exposing (string)
import Json.Decode.Pipeline as Pipeline
import Data.SpaceUser exposing (SpaceUser, spaceUserDecoder)
import GraphQL exposing (Fragment)
import Util exposing (dateDecoder)


-- TYPES


type alias Reply =
    { id : String
    , postId : String
    , body : String
    , bodyHtml : String
    , author : SpaceUser
    , postedAt : Date
    }


fragment : Fragment
fragment =
    GraphQL.fragment
        """
        fragment ReplyFields on Reply {
          id
          postId
          body
          bodyHtml
          author {
            ...SpaceUserFields
          }
          postedAt
        }
        """
        [ Data.SpaceUser.fragment
        ]



-- DECODERS


decoder : Decode.Decoder Reply
decoder =
    Pipeline.decode Reply
        |> Pipeline.required "id" string
        |> Pipeline.required "postId" string
        |> Pipeline.required "body" string
        |> Pipeline.required "bodyHtml" string
        |> Pipeline.required "author" spaceUserDecoder
        |> Pipeline.required "postedAt" dateDecoder
