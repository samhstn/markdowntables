module TryToLines exposing (all)

import Expect
import Fixtures exposing (userInput, userInputLines)
import Test exposing (..)
import Types exposing (UserInput, UserInputErr)
import UserInputToTable exposing (tryToLines)


userInputWithBlankLine : UserInput
userInputWithBlankLine =
    """
| one   | two  |              |   |   |
|-------|------|--------------|---|---|

| three | four |              |   |   |
| five  | six  | ajskdflasjdf |   |   |
|       |      |              |   |   |
"""


userInputWithTrailingLineSpace : UserInput
userInputWithTrailingLineSpace =
    """
| one   | two  |              |   |   |
|-------|------|--------------|---|---|
| three | four |              |   |   |
 | five  | six  | ajskdflasjdf |   |   |
|       |      |              |   |   |
"""


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
