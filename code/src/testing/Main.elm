module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


add : number -> number -> number
add a b =
    a + b


type alias Model =
    { name : String }


initModel : Model
initModel =
    { name = "Jo" }


update : Msg -> Model -> Model
update msg model =
    model


type Msg
    = Clicked


view : Model -> Html Msg
view model =
    div []
        [ text <| "Hello " ++ model.name ]


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initModel
        , view = view
        , update = update
        }
