module Tests exposing (all)

import Expect
import Main exposing (inputToRows, isValidInput)
import Test exposing (..)


basicTableInput : String
basicTableInput =
    "| one | two |\n| three | four |"


tableInput : String
tableInput =
    """
| one   | two  |              |   |   |
|-------|------|--------------|---|---|
| three | four |              |   |   |
| five  | six  | ajskdflasjdf |   |   |
|       |      |              |   |   |
"""


tableRows : List (List String)
tableRows =
    [ [ "one", "two", "", "", "" ]
    , [ "-------", "------", "--------------", "---", "---" ]
    , [ "three", "four", "", "", "" ]
    , [ "five", "six", "ajskdflasjdf", "", "" ]
    , [ "", "", "", "", "" ]
    ]


all : Test
all =
    describe "all" allTests


allTests : List Test
allTests =
    [ describe "inputToRows"
        [ test basicTableInput <|
            \_ ->
                Expect.equal
                    (inputToRows basicTableInput)
                    [ [ "one", "two" ], [ "three", "four" ] ]
        , test tableInput <|
            \_ ->
                Expect.equal (inputToRows tableInput) tableRows
        ]
    , describe "validInput"
        [ test "basicTableInput without trailing |" <|
            \_ ->
                Expect.equal
                    (isValidInput (String.dropRight 1 basicTableInput))
                    False
        , skip <| test "basicTableInput without initial |" <|
            \_ ->
                Expect.equal
                    (isValidInput (String.dropLeft 1 basicTableInput))
                    False
        , skip <| test "tableInput without trailing |" <|
            \_ ->
                Expect.equal
                    (isValidInput (String.dropRight 1 tableInput))
                    False
        , skip <| test "tableInput without initial |" <|
            \_ ->
                Expect.equal
                    (isValidInput (String.dropLeft 1 tableInput))
                    False
        ]
    ]
