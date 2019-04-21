module TryToColumns exposing (all)

import Expect
import Fixtures exposing (userInput, userInputLines, validTableRows)
import Test exposing (..)
import Types exposing (TableRow, UserInputErr)
import UserInputToTable exposing (tryToColumns)


all : Test
all =
    describe "try to columns"
        [ test "valid userInput lines" <|
            \_ ->
                Expect.equal
                    (tryToColumns (Ok userInputLines))
                    (Ok validTableRows)
        ]
