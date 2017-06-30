module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


add : number -> number -> number
add a b =
    a + b


type alias Model =
    { name : String }


initModel : Model
initModel =
    { name = "Jo" }


update : Msg -> Model -> Model
update msg model =
    model


type Msg
    = ClickedAButton
    | ClickedAnotherButton


view : Model -> Html Msg
view model =
    div []
        [ div []
            [ div [ id "name-tag", class "red blue" ]
                [ text <| "Hello " ++ model.name ]
            ]
        , button [ onClick ClickedAButton ] [ text "Click me" ]
        ]


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initModel
        , view = view
        , update = update
        }
