module Main exposing (..)

import Html exposing (..)
import Http exposing (..)


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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Joke (Ok joke) ->
            ( joke, Cmd.none )

        Joke (Err error) ->
            ( error |> toString, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ text model
        ]


randomJoke : Cmd Msg
randomJoke =
    let
        url =
            "https://api.icndb.com/jokes/random"

        request =
            Http.getString url

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
