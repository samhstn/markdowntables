module UserInputToTable exposing (checkBlankLines, checkCorrectColumnLengths, checkCorrectColumnNumbers, checkTrimmableLines, convert, countColumns, countLines, noWrappingBars, tryRemoveHeaderSeparator, tryRemoveSurroundingBars, tryToColumns, tryToLines, tryTrimInput)

import Types exposing (TableRow, UserInput, UserInputErr)


countLines : String -> Int
countLines =
    String.lines >> List.length


countColumns : String -> Int
countColumns =
    String.split "|" >> List.length


tryTrimInput : UserInput -> Result UserInputErr String
tryTrimInput str =
    if String.trim str == str then
        Ok (String.trim str)

    else if countLines (String.trim str) == countLines str then
        if String.trimLeft str /= str then
            Err
                { err = "initial spaces"
                , lines = [ 0 ]
                }

        else
            Err
                { err = "trailing spaces"
                , lines = [ countLines str ]
                }

    else if String.trimLeft str /= str then
        Err
            { err = "initial blank lines"
            , lines =
                List.range
                    0
                    (countLines str - countLines (String.trimLeft str) - 1)
            }

    else
        Err
            { err = "trailing blank lines"
            , lines =
                List.range
                    (countLines (String.trimRight str) + 2)
                    (countLines str + 1)
            }


checkBlankLines : List String -> Result UserInputErr (List String)
checkBlankLines lines =
    let
        blankLines =
            List.indexedMap Tuple.pair lines
                |> List.filter (Tuple.second >> String.trim >> String.isEmpty)
                |> List.map Tuple.first
    in
    if List.isEmpty blankLines then
        Ok lines

    else
        Err { err = "blank lines", lines = blankLines }


checkTrimmableLines :
    Result UserInputErr (List String)
    -> Result UserInputErr (List String)
checkTrimmableLines result =
    case result of
        Ok lines ->
            let
                trimmableLines =
                    List.indexedMap Tuple.pair lines
                        |> List.filter (\( _, line ) -> line /= String.trim line)
                        |> List.map Tuple.first
            in
            if List.isEmpty trimmableLines then
                Ok lines

            else
                Err { err = "trimmable spaces", lines = trimmableLines }

        Err e ->
            Err e


tryToLines :
    Result UserInputErr String
    -> Result UserInputErr (List String)
tryToLines result =
    case result of
        Ok userInput ->
            String.lines userInput
                |> checkBlankLines
                |> checkTrimmableLines

        Err e ->
            Err e


noWrappingBars : String -> Bool
noWrappingBars line =
    not (String.startsWith "|" line) || not (String.endsWith "|" line)


tryRemoveSurroundingBars : List String -> Result UserInputErr (List String)
tryRemoveSurroundingBars lines =
    let
        invalidLines =
            List.indexedMap Tuple.pair lines
                |> List.filter (Tuple.second >> noWrappingBars)
                |> List.map Tuple.first
    in
    if List.isEmpty invalidLines then
        Ok (List.map (String.dropLeft 1 >> String.dropRight 1) lines)

    else
        Err { err = "lines should start and end with a |", lines = invalidLines }


checkCorrectColumnNumbers :
    Result UserInputErr (List String)
    -> Result UserInputErr (List String)
checkCorrectColumnNumbers result =
    case result of
        Ok lines ->
            case List.head lines of
                Just headLine ->
                    let
                        invalidColumnNumberLines =
                            List.indexedMap Tuple.pair lines
                                |> List.filter (\( _, line ) -> countColumns headLine /= countColumns line)
                                |> List.map Tuple.first
                    in
                    if List.isEmpty invalidColumnNumberLines then
                        Ok lines

                    else
                        Err { err = "invalid number of columns compared to table header", lines = invalidColumnNumberLines }

                Nothing ->
                    Err { err = "you need a table header", lines = [ 0 ] }

        Err e ->
            Err e


tryRemoveHeaderSeparator :
    Result UserInputErr (List TableRow)
    -> Result UserInputErr (List TableRow)
tryRemoveHeaderSeparator result =
    case result of
        Ok tableRows ->
            case List.head (List.drop 1 tableRows) of
                Just headerSeparatorRow ->
                    if List.all (String.all (\char -> char == '-')) headerSeparatorRow then
                        List.indexedMap Tuple.pair tableRows
                            |> List.filter (\( i, _ ) -> i /= 1)
                            |> List.map Tuple.second
                            |> Ok

                    else
                        Err { err = "header separator row should only contain - characters", lines = [ 1 ] }

                Nothing ->
                    Err { err = "you need to provide a table separator row", lines = [ 1 ] }

        Err e ->
            Err e


checkCorrectColumnLengths :
    Result UserInputErr (List TableRow)
    -> Result UserInputErr (List TableRow)
checkCorrectColumnLengths result =
    case result of
        Ok tableRows ->
            case List.head tableRows of
                Just headLine ->
                    let
                        invalidColumnLengths =
                            List.indexedMap Tuple.pair tableRows
                                |> List.filter (\( _, tableRow ) -> List.map String.length tableRow /= List.map String.length headLine)
                                |> List.map Tuple.first
                    in
                    if List.isEmpty invalidColumnLengths then
                        Ok tableRows

                    else
                        Err { err = "invalid column length", lines = invalidColumnLengths }

                Nothing ->
                    Err { err = "you need a table header", lines = [ 0 ] }

        Err e ->
            Err e


tryToColumns :
    Result UserInputErr (List String)
    -> Result UserInputErr (List TableRow)
tryToColumns result =
    case result of
        Ok lines ->
            tryRemoveSurroundingBars lines
                |> checkCorrectColumnNumbers
                |> Result.map (List.map (String.split "|"))
                |> checkCorrectColumnLengths
                |> tryRemoveHeaderSeparator
                |> Result.map (List.map (List.map String.trim))

        Err e ->
            Err e


convert : UserInput -> Result UserInputErr (List TableRow)
convert userInput =
    tryTrimInput userInput
        |> tryToLines
        |> tryToColumns
