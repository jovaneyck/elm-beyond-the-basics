module HtmlTests exposing (..)

import Test exposing (..)
import Main exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (..)
import Test.Html.Event as Event


suite : Test
suite =
    describe "HTML testing basics"
        [ test "Can check whether text appears on a page" <|
            \() ->
                Main.view Main.initModel
                    |> Query.fromHtml
                    |> Query.has [ text "Jo" ]
        , test "Can select HTML elements" <|
            \() ->
                Main.view Main.initModel
                    |> Query.fromHtml
                    |> Query.find [ id "name-tag" ]
                    |> Query.has [ text "Jo" ]
        , test "Can assert on stuff like css classes" <|
            \() ->
                Main.view Main.initModel
                    |> Query.fromHtml
                    |> Query.find [ id "name-tag" ]
                    |> Query.has [ classes [ "red", "blue" ] ]
        , test "Can simulate user interaction" <|
            \() ->
                let
                    button =
                        Main.view Main.initModel
                            |> Query.fromHtml
                            |> Query.find [ tag "button" ]
                in
                    button
                        |> Event.simulate Event.click
                        |> Event.expect Main.ClickedAButton
        ]
