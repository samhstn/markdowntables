module Fixtures exposing (lotsBlankLinesUserInput, userInput, userInputLines, userInputWithBlankLine, userInputWithTrailingLineSpace, validTableRows)

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
    , [ "-------", "------", "--------------", "---", "---" ]
    , [ "three", "four", "", "", "" ]
    , [ "five", "six", "ajskdflasjdf", "", "" ]
    , [ "", "", "", "", "" ]
    ]


lotsBlankLinesUserInput : UserInput
lotsBlankLinesUserInput =
    """


| one   | two  |              |   |   |
|-------|------|--------------|---|---|
| three | four |              |   |   |
| five  | six  | ajskdflasjdf |   |   |
|       |      |              |   |   |




"""
