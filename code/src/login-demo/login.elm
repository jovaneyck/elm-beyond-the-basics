module Login exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias Model =
    { username : String
    , password : String
    }


initModel : Model
initModel =
    { username = ""
    , password = ""
    }


type Msg
    = UsernameInput String
    | PasswordInput String


update : Msg -> Model -> Model
update msg model =
    case msg of
        PasswordInput p ->
            { model | password = p }

        UsernameInput u ->
            { model | username = u }


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Login" ]
        , Html.form
            []
            [ input
                [ type_ "text"
                , onInput UsernameInput
                , placeholder "user name"
                ]
                []
            , input
                [ type_ "text"
                , onInput PasswordInput
                , placeholder "password"
                ]
                []
            , button [ type_ "submit" ] [ text "Log in" ]
            ]
        ]


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initModel
        , view = view
        , update = update
        }
