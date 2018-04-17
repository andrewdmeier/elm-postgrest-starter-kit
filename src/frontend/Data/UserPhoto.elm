module Data.UserPhoto exposing (UserPhoto, decoder, attribute, encode, src, toMaybeString)

import Html exposing (Attribute)
import Html.Attributes
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)
import PostgRest as PG


type UserPhoto
    = UserPhoto (Maybe String)


src : UserPhoto -> Attribute msg
src =
    photoToUrl >> Html.Attributes.src


decoder : Decoder UserPhoto
decoder =
    Decode.map UserPhoto (Decode.nullable Decode.string)


encode : UserPhoto -> Value
encode (UserPhoto maybeUrl) =
    Maybe.withDefault Encode.null (Maybe.map Encode.string maybeUrl)


attribute : String -> PG.Attribute UserPhoto
attribute name =
    PG.attribute
        { decoder = decoder
        , encoder = encode
        , urlEncoder = toMaybeString >> Maybe.withDefault "null"
        }
        name


toMaybeString : UserPhoto -> Maybe String
toMaybeString (UserPhoto maybeUrl) =
    maybeUrl



-- INTERNAL --


photoToUrl : UserPhoto -> String
photoToUrl (UserPhoto maybeUrl) =
    case maybeUrl of
        Nothing ->
            "https://static.productionready.io/images/smiley-cyrus.jpg"

        Just url ->
            url
