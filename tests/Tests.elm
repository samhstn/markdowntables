module Tests exposing (all)

import Expect
import Main exposing (inputToRows)
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
    describe "inputToRows"
        [ test basicTableInput <|
            \_ ->
                Expect.equal
                    (inputToRows basicTableInput)
                    [ [ "one", "two" ], [ "three", "four" ] ]
        , test tableInput <|
            \_ ->
                Expect.equal (inputToRows tableInput) tableRows
        ]
