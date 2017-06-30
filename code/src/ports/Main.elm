module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import FireBasePort exposing (..)


-- model


type alias Model =
    { name : String
    , customers : List FireBasePort.Customer
    , error : Maybe String
    , nextId : Int
    }


initModel : Model
initModel =
    { name = ""
    , customers = []
    , error = Nothing
    , nextId = 1
    }


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )



-- update


type Msg
    = NameInput String
    | SaveCustomer
    | CustomerSaved String
    | NewCustomer Customer


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NameInput name ->
            ( { model | name = name }, Cmd.none )

        SaveCustomer ->
            -- Don't touch the model, just push a command to the firebase port
            ( model, FireBasePort.addCustomer model.name )

        CustomerSaved key ->
            ( { model | name = "" }, Cmd.none )

        NewCustomer customer ->
            ( { model | customers = customer :: model.customers }, Cmd.none )



-- view


viewCustomer : Customer -> Html Msg
viewCustomer customer =
    li []
        [ i [ class "remove" ] []
        , text customer.name
        ]


viewCustomers : List Customer -> Html Msg
viewCustomers customers =
    customers
        |> List.sortBy .id
        |> List.map viewCustomer
        |> ul []


viewCustomerForm : Model -> Html Msg
viewCustomerForm model =
    Html.form [ onSubmit SaveCustomer ]
        [ input [ type_ "text", onInput NameInput, value model.name ] []
        , text <| Maybe.withDefault "" model.error
        , button [ type_ "submit" ] [ text "Save" ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Customer List" ]
        , viewCustomerForm model
        , viewCustomers model.customers
        ]



-- subscription


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ FireBasePort.customerSaved CustomerSaved
        , FireBasePort.newCustomer NewCustomer
        ]


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
