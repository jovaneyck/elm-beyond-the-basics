module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)


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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ToggleStreaming ->
            let
                newModel =
                    { model | streamTime = not model.streamTime }
            in
                ( newModel, Cmd.none )



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


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
