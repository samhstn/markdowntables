module Main exposing (init, inputView, main, tableColumns, tableView, update, view)

import Browser
import Html exposing (Html, div, h1, table, td, text, textarea, tr)
import Html.Attributes exposing (class, value)
import Html.Events exposing (onInput)
import Types
    exposing
        ( Model
        , Msg(..)
        , TableRow
        , UserInput
        , UserInputErr
        )
import UserInputToTable


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


init : Model
init =
    case UserInputToTable.convert "| one | two |\n|-----|-----|\n| three | four |" of
        Ok tableRows ->
            { userInput = "| one | two |\n|-----|-----|\n| three | four |"
            , tableRows = tableRows
            }

        Err _ ->
            { userInput = "", tableRows = [] }


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        Input userInput ->
            case UserInputToTable.convert userInput of
                Ok tableRows ->
                    { userInput = userInput
                    , tableRows = tableRows
                    }

                Err _ ->
                    { model | userInput = userInput }


view : Model -> Html Msg
view model =
    div
        [ class "container" ]
        [ div
            [ class "header"
            ]
            [ h1 [] [ text "Table Converter" ]
            ]
        , div
            [ class "table-container"
            ]
            [ tableView model.tableRows
            ]
        , div
            [ class "input-container"
            ]
            [ inputView model.userInput
            ]
        , div
            [ class "footer"
            ]
            [ div [] [ text "footer" ]
            ]
        ]


tableView : List TableRow -> Html Msg
tableView tableRows =
    table
        []
        (List.map (\row -> tr [] (tableColumns row)) tableRows)


tableColumns : TableRow -> List (Html Msg)
tableColumns =
    List.map (\column -> td [] [ text column ])


inputView : UserInput -> Html Msg
inputView userInput =
    div
        []
        [ textarea
            [ value userInput
            , onInput Input
            ]
            []
        , case UserInputToTable.convert userInput of
            Ok _ ->
                text ""

            Err { err, lines } ->
                div
                    [ class "red" ]
                    [ text (err ++ ". Lines: " ++ String.join ", " (List.map String.fromInt lines))
                    ]
        ]
