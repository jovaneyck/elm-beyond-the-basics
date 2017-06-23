module JSON exposing (..)

import Json.Decode exposing (..)
import Test exposing (..)
import Expect


--How to run: <elm-test --watch> in root of project


suite : Test
suite =
    describe "JSON Decoding"
        [ test "Can extract a value from somewhere in a JSON object" <|
            \() ->
                let
                    jokeDecoder =
                        at [ "value", "joke" ] string

                    json =
                        """
                        {
                        "type": "success",
                        "value": {
                          "id": 541,
                          "joke": "When Chuck Norris break the build, you can't fix it, because there is not a single line of code left.",
                          "categories": ["nerdy"] } }
                        """
                in
                    Expect.equal
                        (decodeString jokeDecoder json)
                        (Result.Ok "When Chuck Norris break the build, you can't fix it, because there is not a single line of code left.")
        ]
