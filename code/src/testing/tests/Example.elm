module Example exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, string)
import Main exposing (..)
import String


--How to run: <elm-test --watch> in root of project


suite : Test
suite =
    describe "Testing basics"
        [ test "Can do basic assertions" <|
            \() ->
                let
                    actual =
                        add 3 2
                in
                    Expect.equal actual 5
        , fuzz string "Can test properties" <|
            \aString ->
                aString
                    |> String.reverse
                    |> String.reverse
                    |> Expect.equal aString
        ]
