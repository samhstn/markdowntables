module UserInputToTable exposing (checkBlankLines, checkTrimmableLines, convert, countLines, tryToColumns, tryToLines, tryTrimInput)

import Types exposing (TableRow, UserInput, UserInputErr)


countLines : String -> Int
countLines =
    String.lines >> List.length


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



-- todo


tryRemoveHeaderSeparator :
    Result UserInputErr (List String)
    -> Result UserInputErr (List String)
tryRemoveHeaderSeparator result =
    case result of
        Ok userInput ->
            Ok userInput

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
                |> tryRemoveHeaderSeparator

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



-- todo


checkCorrectColumnLengths :
    Result UserInputErr (List (List String))
    -> Result UserInputErr (List (List String))
checkCorrectColumnLengths result =
    case result of
        Ok tableRows ->
            Ok tableRows

        Err e ->
            Err e


tryToColumns :
    Result UserInputErr (List String)
    -> Result UserInputErr (List TableRow)
tryToColumns result =
    case result of
        Ok lines ->
            tryRemoveSurroundingBars lines
                |> Result.map (List.map (String.split "|"))
                |> checkCorrectColumnLengths
                |> Result.map (List.map (List.map String.trim))

        Err e ->
            Err e


convert : UserInput -> Result UserInputErr (List TableRow)
convert userInput =
    tryTrimInput userInput
        |> tryToLines
        |> tryToColumns
