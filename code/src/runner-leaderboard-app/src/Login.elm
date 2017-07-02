module Login exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Http exposing (..)
import Json.Encode exposing (..)
import Json.Decode exposing (field)
import Navigation exposing (..)


-- model


type alias Model =
    { username : String
    , password : String
    , error : Maybe String
    }


initModel : Model
initModel =
    { username = ""
    , password = ""
    , error = Nothing
    }


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )



-- update


type Msg
    = UsernameInput String
    | PasswordInput String
    | Submit
    | Error String
    | LoginResponse (Result Http.Error String)


url : String
url =
    "http://localhost:5000/authenticate"


update : Msg -> Model -> ( Model, Cmd Msg, Maybe String )
update msg model =
    case msg of
        UsernameInput username ->
            ( { model | username = username }, Cmd.none, Nothing )

        PasswordInput password ->
            ( { model | password = password }, Cmd.none, Nothing )

        Submit ->
            let
                body =
                    Json.Encode.object
                        [ ( "username", Json.Encode.string model.username )
                        , ( "password", Json.Encode.string model.password )
                        ]
                        |> Json.Encode.encode 4
                        |> Http.stringBody "application/json"

                decoder =
                    Json.Decode.field "token" Json.Decode.string

                request =
                    Http.post url body decoder

                cmd =
                    Http.send LoginResponse request
            in
                ( model, cmd, Nothing )

        LoginResponse (Ok token) ->
            --clear username & password from the model!
            ( initModel, Navigation.newUrl "#/", Just token )

        LoginResponse (Err err) ->
            let
                errMsg =
                    case err of
                        Http.BadStatus resp ->
                            case resp.status.code of
                                401 ->
                                    resp.body

                                _ ->
                                    resp.status.message

                        _ ->
                            "Oops, something went wrong when logging in :("
            in
                ( { model | error = Just errMsg }, Cmd.none, Nothing )

        Error error ->
            ( { model | error = Just error }, Cmd.none, Nothing )



-- view


view : Model -> Html Msg
view model =
    div [ class "main" ]
        [ errorPanel model.error
        , loginForm model
        ]


loginForm : Model -> Html Msg
loginForm model =
    Html.form [ class "add-runner", onSubmit Submit ]
        [ fieldset []
            [ legend [] [ text "Login" ]
            , div []
                [ label [] [ text "User Name" ]
                , input
                    [ type_ "text"
                    , value model.username
                    , onInput UsernameInput
                    ]
                    []
                ]
            , div []
                [ label [] [ text "Password" ]
                , input
                    [ type_ "password"
                    , value model.password
                    , onInput PasswordInput
                    ]
                    []
                ]
            , div []
                [ label [] []
                , button [ type_ "submit" ] [ text "Login" ]
                ]
            ]
        ]


errorPanel : Maybe String -> Html a
errorPanel error =
    case error of
        Nothing ->
            text ""

        Just msg ->
            div [ class "error" ]
                [ text msg ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
