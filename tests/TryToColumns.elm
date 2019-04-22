module TryToColumns exposing (all)

import Expect
import Fixtures exposing (userInput, userInputLines, validTableRows)
import Test exposing (..)
import Types exposing (TableRow)
import UserInputToTable exposing (checkCorrectColumnLengths, checkCorrectColumnNumbers, tryRemoveHeaderSeparator, tryRemoveSurroundingBars, tryToColumns)


invalidSurroundBarsUserInputLines : List String
invalidSurroundBarsUserInputLines =
    [ "| one   | two  |              |   |   |"
    , "|-------|------|--------------|---|---|"
    , "a| three | four |              |   |   |"
    , "| five  | six  | ajskdflasjdf |   |   |"
    , "|       |      |              |   |   |"
    ]


removedSurroundingBars : List String
removedSurroundingBars =
    [ " one   | two  |              |   |   "
    , "-------|------|--------------|---|---"
    , " three | four |              |   |   "
    , " five  | six  | ajskdflasjdf |   |   "
    , "       |      |              |   |   "
    ]


untrimmedTableRows : List TableRow
untrimmedTableRows =
    [ [ " one   ", " two  ", "              ", "   ", "   " ]
    , [ "-------", "------", "--------------", "---", "---" ]
    , [ " three ", " four ", "              ", "   ", "   " ]
    , [ " five  ", " six  ", " ajskdflasjdf ", "   ", "   " ]
    , [ "       ", "      ", "              ", "   ", "   " ]
    ]


nonMatchingColumnNumber : List String
nonMatchingColumnNumber =
    [ " one   | two  |              |   |   "
    , "-------|------"
    , " three | four |              |   |   "
    , " five  | six  | ajskdflasjdf |   |   "
    , "       |      |              |   |   "
    ]


nonMatchingColumnLength : List TableRow
nonMatchingColumnLength =
    [ [ " one   ", " two  ", "              ", "   ", "   " ]
    , [ "-------", "------", "--------------", "---", "--" ]
    , [ " three ", " four ", "              ", "   ", "   " ]
    , [ " five  ", " six  ", " ajskdflasjdf ", "   ", "   " ]
    , [ "       ", " ", "             ", "   ", "   " ]
    ]


invalidHeaderSeparator : List TableRow
invalidHeaderSeparator =
    [ [ " one   ", " two  ", "              ", "   ", "   " ]
    , [ "-------", "------", "--------------", "---", "-- " ]
    , [ " three ", " four ", "              ", "   ", "   " ]
    , [ " five  ", " six  ", " ajskdflasjdf ", "   ", "   " ]
    , [ "       ", "      ", "              ", "   ", "   " ]
    ]


removedHeaderSeparator : List TableRow
removedHeaderSeparator =
    [ [ " one   ", " two  ", "              ", "   ", "   " ]
    , [ " three ", " four ", "              ", "   ", "   " ]
    , [ " five  ", " six  ", " ajskdflasjdf ", "   ", "   " ]
    , [ "       ", "      ", "              ", "   ", "   " ]
    ]


all : Test
all =
    describe "try to columns"
        [ test "valid userInput lines" <|
            \_ ->
                Expect.equal
                    (tryToColumns (Ok userInputLines))
                    (Ok validTableRows)
        , describe "try remove surrounding bars" <|
            [ test "invalid starting bar" <|
                \_ ->
                    Expect.equal
                        (tryToColumns (Ok invalidSurroundBarsUserInputLines))
                        (Err { err = "lines should start and end with a |", lines = [ 2 ] })
            , test "valid bars" <|
                \_ ->
                    Expect.equal
                        (tryRemoveSurroundingBars userInputLines)
                        (Ok removedSurroundingBars)
            ]
        , describe "check correct column numbers" <|
            [ test "valid" <|
                \_ ->
                    Expect.equal
                        (checkCorrectColumnNumbers (Ok removedSurroundingBars))
                        (Ok removedSurroundingBars)
            , test "invalid column number" <|
                \_ ->
                    Expect.equal
                        (checkCorrectColumnNumbers (Ok nonMatchingColumnNumber))
                        (Err { err = "invalid number of columns compared to table header", lines = [ 1 ] })
            ]
        , describe "check correct column lengths" <|
            [ test "valid" <|
                \_ ->
                    Expect.equal
                        (checkCorrectColumnLengths (Ok untrimmedTableRows))
                        (Ok untrimmedTableRows)
            , test "invalid column length" <|
                \_ ->
                    Expect.equal
                        (checkCorrectColumnLengths (Ok nonMatchingColumnLength))
                        (Err { err = "invalid column length", lines = [ 1, 4 ] })
            ]
        , describe "try remove header separator" <|
            [ test "valid" <|
                \_ ->
                    Expect.equal
                        (tryRemoveHeaderSeparator (Ok untrimmedTableRows))
                        (Ok removedHeaderSeparator)
            , test "invalid header separator" <|
                \_ ->
                    Expect.equal
                        (tryRemoveHeaderSeparator (Ok invalidHeaderSeparator))
                        (Err { err = "header separator row should only contain - characters", lines = [ 1 ] })
            ]
        ]
