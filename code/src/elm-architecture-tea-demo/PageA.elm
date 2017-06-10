module PageA exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias Model =
    { name : String }


initModel : Model
initModel =
    { name = "Bob" }


type Msg
    = NameChange String


update : Msg -> Model -> Model
update msg model =
    case msg of
        NameChange new ->
            { model | name = new }


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text <| "Hey " ++ model.name ]
        , input [ type_ "text", value model.name, onInput NameChange ] []
        ]
