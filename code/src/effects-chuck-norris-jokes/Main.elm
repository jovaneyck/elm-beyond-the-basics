module Main exposing (..)

import Html exposing (..)


type alias Model =
    String


initModel : Model
initModel =
    "Finding a joke..."


type Msg
    = Joke String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Joke joke ->
            joke


view : Model -> Html Msg
view model =
    div []
        [ text model
        ]


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initModel
        , view = view
        , update = update
        }
