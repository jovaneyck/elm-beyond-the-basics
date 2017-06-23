module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import WebSocket exposing (..)
import Json.Decode exposing (..)


-- model


type alias Model =
    { streamTime : Bool
    , time : String
    }


initModel : Model
initModel =
    { streamTime = False
    , time = ""
    }


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )



-- update


type Msg
    = ToggleStreaming
    | Time String


decoder : String -> Msg
decoder message =
    decodeString (at [ "time" ] string) message
        |> Result.withDefault "Could not parse time"
        |> Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleStreaming ->
            let
                newModel =
                    { model | streamTime = not model.streamTime }

                msg =
                    if newModel.streamTime then
                        "start"
                    else
                        "stop"

                cmd =
                    send wsUrl msg
            in
                ( newModel, cmd )

        Time t ->
            ( { model | time = t }, Cmd.none )



-- view


view : Model -> Html Msg
view model =
    let
        toggleLabel =
            if model.streamTime then
                "Stop"
            else
                "Start"
    in
        div []
            [ button [ onClick ToggleStreaming ] [ text toggleLabel ]
            , br [] []
            , text model.time
            ]


wsUrl : String
wsUrl =
    "ws://localhost:5000"


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.streamTime then
        listen wsUrl decoder
    else
        Sub.none


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
