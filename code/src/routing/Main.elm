module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Navigation exposing (..)


type Page
    = LeaderBoard
    | AddRunner
    | Login
    | NotFound


type alias Model =
    { page : Page
    }


initModel : Page -> Model
initModel page =
    -- Now takes a PAGE input
    { page = page }


init : Location -> ( Model, Cmd Msg )
init location =
    --init is now a FUNCTION that takes the initial Location (i.e. URL).
    let
        page =
            hashToPage location.hash
    in
        ( initModel page, Cmd.none )


type Msg
    = Navigate Page
    | ChangePage Page


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        --don't change model, request a URL change and let everything cascade from there
        Navigate page ->
            ( model, Navigation.newUrl <| pageToHash page )

        ChangePage page ->
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


pageToHash : Page -> String
pageToHash page =
    case page of
        LeaderBoard ->
            "#leader"

        AddRunner ->
            "#add"

        Login ->
            "#login"

        NotFound ->
            "#notfound"


hashToPage : String -> Page
hashToPage hash =
    case hash of
        "#leader" ->
            LeaderBoard

        "" ->
            LeaderBoard

        "#add" ->
            AddRunner

        "#login" ->
            Login

        _ ->
            NotFound


locationToMsg : Location -> Msg
locationToMsg location =
    location.hash
        |> hashToPage
        |> ChangePage


main : Program Never Model Msg
main =
    Navigation.program locationToMsg
        --Instead of Html.program!
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
