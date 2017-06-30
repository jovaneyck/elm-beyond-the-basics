module HtmlTests exposing (..)

import Test exposing (..)
import Main exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (..)


suite : Test
suite =
    describe "HTML testing basics"
        [ test "Can check whether certain text appears on a page" <|
            \() ->
                Main.view Main.initModel
                    |> Query.fromHtml
                    |> Query.has [ text "Jo" ]
        ]
