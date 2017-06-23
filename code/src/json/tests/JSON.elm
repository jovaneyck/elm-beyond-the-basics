module JSON exposing (..)

import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required, optional)
import Test exposing (..)
import Expect


--How to run: <elm-test --watch> in root of project


json : String
json =
    """
    {
      "type": "success",
      "value":
      {
        "id": 541,
        "joke": "When Chuck Norris break the build, you can't fix it, because there is not a single line of code left.",
        "categories": ["nerdy"]
      }
    }
    """


type alias Joke =
    { id : Int
    , joke : String
    , categories : List String
    }


suite : Test
suite =
    describe "JSON Decoding"
        [ test "Can extract a value from somewhere in a JSON object" <|
            \() ->
                let
                    jokeDecoder =
                        at [ "value", "joke" ] string
                in
                    Expect.equal
                        (decodeString jokeDecoder json)
                        (Ok "When Chuck Norris break the build, you can't fix it, because there is not a single line of code left.")
        , test "Returns errors when cannot parse using the Result type" <|
            \() ->
                let
                    wrongDecoder =
                        at [ "foo" ] int

                    decodeResult =
                        decodeString wrongDecoder json
                in
                    Expect.equal
                        decodeResult
                        (Err "Expecting an object with a field named `foo` but instead got: {\"type\":\"success\",\"value\":{\"id\":541,\"joke\":\"When Chuck Norris break the build, you can't fix it, because there is not a single line of code left.\",\"categories\":[\"nerdy\"]}}")
        , test "Can extract into record types" <|
            \() ->
                let
                    decoder =
                        map3 Joke
                            (field "id" int)
                            (field "joke" string)
                            (field "categories" (list string))
                            |> at [ "value" ]
                in
                    Expect.equal
                        (decodeString decoder json)
                        (Ok
                            { id = 541
                            , joke = "When Chuck Norris break the build, you can't fix it, because there is not a single line of code left."
                            , categories = [ "nerdy" ]
                            }
                        )
        , test "Json.Decode.Pipeline provides more flexibility" <|
            \() ->
                let
                    decoder =
                        decode Joke
                            |> required "id" int
                            |> required "joke" string
                            --default to empty list if nothing found
                            |> optional "categories" (list string) []
                            |> at [ "value" ]
                in
                    Expect.equal
                        (decodeString decoder json)
                        (Ok
                            { id = 541
                            , joke = "When Chuck Norris break the build, you can't fix it, because there is not a single line of code left."
                            , categories = [ "nerdy" ]
                            }
                        )
        ]
