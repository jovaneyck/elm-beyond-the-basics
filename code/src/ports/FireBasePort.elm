port module FireBasePort exposing (..)


type alias Customer =
    { id : String
    , name : String
    }


port addCustomer : String -> Cmd msg


port customerSaved : (String -> msg) -> Sub msg


port newCustomer : (Customer -> msg) -> Sub msg
