module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import PageA
import PageB


type Page
    = A
    | B


type alias Model =
    { page : Page
    , aModel : PageA.Model
    , bModel : PageB.Model
    }


initModel : Model
initModel =
    { page = A
    , aModel = PageA.initModel
    , bModel = PageB.initModel
    }


type Msg
    = PageChange Page
    | AMsg PageA.Msg
    | BMsg PageB.Msg


update : Msg -> Model -> Model
update msg model =
    case msg of
        PageChange p ->
            { model | page = p }

        AMsg msg ->
            { model | aModel = PageA.update msg model.aModel }

        BMsg msg ->
            { model | bModel = PageB.update msg model.bModel }


view : Model -> Html Msg
view model =
    let
        page =
            case model.page of
                A ->
                    PageA.view model.aModel |> Html.map AMsg

                B ->
                    PageB.view model.bModel |> Html.map BMsg
    in
        div []
            [ span [ onClick (PageChange A) ] [ text "A" ]
            , text " | "
            , span [ onClick (PageChange B) ] [ text "B" ]
            , hr [] []
            , page
            ]


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initModel
        , view = view
        , update = update
        }
