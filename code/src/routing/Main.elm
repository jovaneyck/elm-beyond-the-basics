module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)


type Page
    = LeaderBoard
    | AddRunner
    | Login
    | NotFound


type alias Model =
    { page : Page
    }


initModel : Model
initModel =
    { page = LeaderBoard }


type Msg
    = Navigate Page


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Navigate page ->
            ( { model | page = page }, Cmd.none )


menu : Model -> Html Msg
menu model =
    header []
        [ a [ onClick (Navigate LeaderBoard) ]
            [ text "LeaderBoard" ]
        , text " | "
        , a [ onClick (Navigate AddRunner) ]
            [ text "Add Runner" ]
        , text " | "
        , a [ onClick (Navigate Login) ]
            [ text "Login" ]
        ]


viewPage : String -> Html Msg
viewPage pageDescription =
    div []
        [ h3 [] [ text pageDescription ]
        , p [] [ text <| "TODO: make " ++ pageDescription ]
        ]


view : Model -> Html Msg
view model =
    let
        page =
            case model.page of
                LeaderBoard ->
                    viewPage "LeaderBoard Page"

                AddRunner ->
                    viewPage "Add Runner Page"

                Login ->
                    viewPage "Login Page"

                NotFound ->
                    viewPage "Page Not Found"
    in
        div []
            [ menu model
            , hr [] []
            , page
            ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never Model Msg
main =
    Html.program
        { init = ( initModel, Cmd.none )
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
