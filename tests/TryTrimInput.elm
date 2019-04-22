module TryTrimInput exposing (all)

import Expect
import Fixtures exposing (userInput)
import Test exposing (..)
import Types exposing (UserInput)
import UserInputToTable exposing (tryTrimInput)


lotsBlankLinesUserInput : UserInput
lotsBlankLinesUserInput =
    """


| one   | two  |              |   |   |
|-------|------|--------------|---|---|
| three | four |              |   |   |
| five  | six  | ajskdflasjdf |   |   |
|       |      |              |   |   |




"""


all : Test
all =
    describe "try trim input"
        [ test "with inital and trailing blank lines" <|
            \_ ->
                Expect.equal
                    (tryTrimInput userInput)
                    (Err { err = "initial blank lines", lines = [ 0 ] })
        , test "with trailing blank lines" <|
            \_ ->
                Expect.equal
                    (tryTrimInput (String.trimLeft userInput))
                    (Err { err = "trailing blank lines", lines = [ 7 ] })
        , test "no trailing lines" <|
            \_ ->
                Expect.equal
                    (tryTrimInput (String.trim userInput))
                    (Ok (String.trim userInput))
        , test "lots initial and trailing blank lines" <|
            \_ ->
                Expect.equal
                    (tryTrimInput lotsBlankLinesUserInput)
                    (Err { err = "initial blank lines", lines = [ 0, 1, 2 ] })
        , test "lots trailing blank lines" <|
            \_ ->
                Expect.equal
                    (tryTrimInput (String.trimLeft lotsBlankLinesUserInput))
                    (Err { err = "trailing blank lines", lines = [ 7, 8, 9, 10, 11 ] })
        , test "trailing spaces" <|
            \_ ->
                Expect.equal
                    (tryTrimInput (String.trim userInput ++ " "))
                    (Err { err = "trailing spaces", lines = [ 5 ] })
        , test "initial spaces" <|
            \_ ->
                Expect.equal
                    (tryTrimInput (" " ++ String.trim userInput))
                    (Err { err = "initial spaces", lines = [ 0 ] })
        ]
