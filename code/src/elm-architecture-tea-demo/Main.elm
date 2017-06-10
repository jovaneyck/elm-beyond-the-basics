module Main exposing (..)

import Html exposing (..)
import PageA


main : Program Never PageA.Model PageA.Msg
main =
    Html.beginnerProgram
        { model = PageA.initModel
        , view = PageA.view
        , update = PageA.update
        }
