module Fixtures exposing (userInput, userInputLines, validTableRows)

import Types exposing (TableRow, UserInput)


userInput : UserInput
userInput =
    """
| one   | two  |              |   |   |
|-------|------|--------------|---|---|
| three | four |              |   |   |
| five  | six  | ajskdflasjdf |   |   |
|       |      |              |   |   |
"""


userInputLines : List String
userInputLines =
    [ "| one   | two  |              |   |   |"
    , "|-------|------|--------------|---|---|"
    , "| three | four |              |   |   |"
    , "| five  | six  | ajskdflasjdf |   |   |"
    , "|       |      |              |   |   |"
    ]


validTableRows : List TableRow
validTableRows =
    [ [ "one", "two", "", "", "" ]
    , [ "three", "four", "", "", "" ]
    , [ "five", "six", "ajskdflasjdf", "", "" ]
    , [ "", "", "", "", "" ]
    ]
