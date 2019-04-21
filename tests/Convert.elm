module Convert exposing (invalidUserInputTest, validUserInputTest)

import Expect
import Fixtures exposing (userInput, validTableRows)
import Test exposing (..)
import Types exposing (TableRow, UserInput, UserInputErr)
import UserInputToTable


-- todo
invalidUserInputs : List ( UserInput, UserInputErr )
invalidUserInputs =
    [ ( "| ", { err = "trailing spaces", lines = [ 1 ] } )
    ]


invalidUserInputTest : Test
invalidUserInputTest =
    describe "invalid user input"
        (List.map
            (\( input, { err, lines } ) ->
                test input <|
                    \_ ->
                        Expect.equal
                            (UserInputToTable.convert input)
                            (Err { err = err, lines = lines })
            )
            invalidUserInputs
        )


validUserInputTest : Test
validUserInputTest =
    describe "valid user input"
        [ test userInput <|
            \_ ->
                Expect.equal
                    (UserInputToTable.convert (String.trim userInput))
                    (Ok validTableRows)
        ]
