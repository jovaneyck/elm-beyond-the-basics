module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Json.Decode exposing (..)


type alias Model =
    String


initModel : Model
initModel =
    "Finding a joke..."


init : ( Model, Cmd Msg )
init =
    ( initModel, randomJoke )


type Msg
    = Joke (Result Error String)
    | RequestNewJoke


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RequestNewJoke ->
            ( model, randomJoke )

        Joke (Ok joke) ->
            ( joke, Cmd.none )

        Joke (Err error) ->
            ( error |> toString, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick RequestNewJoke ] [ text "New joke" ]
        , br [] []
        , text model
        ]


randomJoke : Cmd Msg
randomJoke =
    let
        url =
            "https://api.icndb.com/jokes/random"

        request =
            Http.get url (at [ "value", "joke" ] string)

        cmd =
            Http.send Joke request
    in
        cmd


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
