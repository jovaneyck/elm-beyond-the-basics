port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Navigation exposing (..)
import LeaderBoard exposing (..)


-- model


type alias Model =
    { page : Page
    , leaderBoardModel : LeaderBoard.Model
    }


type Page
    = NotFound
    | LeaderBoard


init : Location -> ( Model, Cmd Msg )
init location =
    let
        page =
            hashToPage location.hash

        ( leaderBoardModel, leaderBoardCmd ) =
            LeaderBoard.init

        initModel =
            ({ page = page
             , leaderBoardModel = leaderBoardModel
             }
            )

        cmds =
            Cmd.batch
                [ Cmd.map LeaderBoardMsg leaderBoardCmd ]
    in
        ( initModel, cmds )



-- update


type Msg
    = Navigate Page
    | ChangePage Page
    | LeaderBoardMsg LeaderBoard.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Navigate page ->
            ( model, Navigation.newUrl <| pageToHash page )

        ChangePage page ->
            ( { model | page = page }, Cmd.none )

        LeaderBoardMsg msg ->
            let
                ( lbmodel, cmd ) =
                    LeaderBoard.update msg model.leaderBoardModel
            in
                ( { model | leaderBoardModel = lbmodel }
                , Cmd.map LeaderBoardMsg cmd
                )



-- view


view : Model -> Html Msg
view model =
    let
        page =
            case model.page of
                LeaderBoard ->
                    LeaderBoard.view model.leaderBoardModel
                        |> Html.map LeaderBoardMsg

                NotFound ->
                    div [ class "main" ]
                        [ h1 []
                            [ text "Page Not Found!" ]
                        ]
    in
        div []
            [ pageHeader model
            , page
            ]


pageHeader : Model -> Html Msg
pageHeader model =
    header []
        [ a [ onClick <| Navigate LeaderBoard ] [ text "Race Results" ]
        , ul []
            [ li []
                [ a [ href "#" ] [ text "Link" ]
                ]
            ]
        , ul []
            [ li []
                [ a [ href "#" ] [ text "Login" ]
                ]
            ]
        ]



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        lb =
            LeaderBoard.subscriptions model.leaderBoardModel
                |> Sub.map LeaderBoardMsg
    in
        Sub.batch
            [ lb ]


pageToHash : Page -> String
pageToHash page =
    case page of
        LeaderBoard ->
            "#/"

        NotFound ->
            "#/notfound"


hashToPage : String -> Page
hashToPage hash =
    case hash of
        "#/" ->
            LeaderBoard

        "" ->
            LeaderBoard

        _ ->
            NotFound


locationToMsg : Location -> Msg
locationToMsg location =
    location.hash
        |> hashToPage
        |> ChangePage


main : Program Never Model Msg
main =
    Navigation.program
        locationToMsg
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
