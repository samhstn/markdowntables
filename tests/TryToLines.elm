module TryToLines exposing (all)

import Expect
import Fixtures exposing (userInput, userInputLines, userInputWithBlankLine, userInputWithTrailingLineSpace)
import Test exposing (..)
import Types exposing (UserInputErr)
import UserInputToTable exposing (tryToLines)


all : Test
all =
    describe "try to lines"
        [ test "trimmed UserInput" <|
            \_ ->
                Expect.equal
                    (tryToLines (Ok (String.trim userInput)))
                    (Ok userInputLines)
        , test "with blank lines" <|
            \_ ->
                Expect.equal
                    (tryToLines (Ok (String.trim userInputWithBlankLine)))
                    (Err { err = "blank lines", lines = [ 2 ] })
        , test "with trimmable spaces" <|
            \_ ->
                Expect.equal
                    (tryToLines (Ok (String.trim userInputWithTrailingLineSpace)))
                    (Err { err = "trimmable spaces", lines = [ 3 ] })
        ]
