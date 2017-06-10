module Example exposing (..)

import Test exposing (..)
import Expect
import Fuzz exposing (list, int, string)
import Main exposing (..)
import String


suite : Test
suite =
    describe "Testing basics"
        [ test "Can do basic assertions" <|
            \_ ->
                let
                    actual =
                        add 2 3
                in
                    Expect.equal 5 actual
        , fuzz string "Can test properties" <|
            \aString ->
                aString
                    |> String.reverse
                    |> String.reverse
                    |> Expect.equal aString
        ]
