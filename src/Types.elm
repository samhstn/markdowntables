module Types exposing (Model, Msg(..), TableRow, UserInput, UserInputErr)


type Msg
    = NoOp
    | Input UserInput


type alias Model =
    { userInput : UserInput
    , tableRows : List TableRow
    }


type alias UserInput =
    String


type alias TableRow =
    List String


type alias UserInputErr =
    { err : String
    , lines : List Int
    }
