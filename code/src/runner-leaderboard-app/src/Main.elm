port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Navigation exposing (..)
import LeaderBoard exposing (..)
import Login exposing (..)
import AddRunner exposing (..)


-- model


type alias Model =
    { page : Page
    , leaderBoardModel : LeaderBoard.Model
    , loginModel : Login.Model
    , addRunnerModel : AddRunner.Model
    , token : Maybe String
    , loggedIn : Bool
    }


type Page
    = NotFound
    | LeaderBoard
    | Login
    | AddRunner


init : Location -> ( Model, Cmd Msg )
init location =
    let
        page =
            hashToPage location.hash

        ( leaderBoardModel, leaderBoardCmd ) =
            LeaderBoard.init

        ( loginModel, loginCmd ) =
            Login.init

        ( addModel, addCmd ) =
            AddRunner.init

        initModel =
            ({ page = page
             , leaderBoardModel = leaderBoardModel
             , loginModel = loginModel
             , addRunnerModel = addModel
             , token = Nothing
             , loggedIn = False
             }
            )

        cmds =
            Cmd.batch
                [ Cmd.map LeaderBoardMsg leaderBoardCmd
                , Cmd.map LoginMsg loginCmd
                , Cmd.map AddRunnerMsg addCmd
                ]
    in
        ( initModel, cmds )



-- update


type Msg
    = Navigate Page
    | ChangePage Page
    | LeaderBoardMsg LeaderBoard.Msg
    | LoginMsg Login.Msg
    | AddRunnerMsg AddRunner.Msg


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

        LoginMsg msg ->
            let
                ( lmodel, cmd, token ) =
                    Login.update msg model.loginModel

                loggedIn =
                    token /= Nothing
            in
                ( { model
                    | loginModel = lmodel
                    , token = token
                    , loggedIn = loggedIn
                  }
                , Cmd.map LoginMsg cmd
                )

        AddRunnerMsg msg ->
            let
                ( rmodel, cmd ) =
                    AddRunner.update msg model.addRunnerModel
            in
                ( { model | addRunnerModel = rmodel }
                , Cmd.map AddRunnerMsg cmd
                )



-- view


view : Model -> Html Msg
view model =
    let
        page =
            case model.page of
                Login ->
                    Login.view model.loginModel
                        |> Html.map LoginMsg

                LeaderBoard ->
                    LeaderBoard.view model.leaderBoardModel
                        |> Html.map LeaderBoardMsg

                AddRunner ->
                    AddRunner.view model.addRunnerModel
                        |> Html.map AddRunnerMsg

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
                [ a [ onClick <| Navigate AddRunner ] [ text "Add a new runner" ]
                ]
            ]
        , ul []
            [ li []
                [ a [ onClick <| Navigate Login ] [ text "Login" ]
                ]
            ]
        ]



-- subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        login =
            Login.subscriptions model.loginModel
                |> Sub.map LoginMsg

        lb =
            LeaderBoard.subscriptions model.leaderBoardModel
                |> Sub.map LeaderBoardMsg

        add =
            AddRunner.subscriptions model.addRunnerModel
                |> Sub.map AddRunnerMsg
    in
        Sub.batch
            [ lb
            , login
            , add
            ]


pageToHash : Page -> String
pageToHash page =
    case page of
        LeaderBoard ->
            "#/"

        Login ->
            "#/login"

        AddRunner ->
            "#/add"

        NotFound ->
            "#/notfound"


hashToPage : String -> Page
hashToPage hash =
    case hash of
        "#/" ->
            LeaderBoard

        "" ->
            LeaderBoard

        "#/login" ->
            Login

        "#/add" ->
            AddRunner

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
