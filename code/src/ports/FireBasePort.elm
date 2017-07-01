port module FireBasePort exposing (..)


type alias Customer =
    { id : String
    , name : String
    }


port addCustomer : String -> Cmd msg


port customerSaved : (String -> msg) -> Sub msg


port newCustomer : (Customer -> msg) -> Sub msg


port deleteCustomer : Customer -> Cmd msg


port customerDeleted : (String -> msg) -> Sub msg
