module Main exposing (init, inputView, main, tableColumns, tableView, update, view)

import Browser
import Html exposing (Html, div, h1, table, td, text, textarea, tr)
import Html.Attributes exposing (class, style, value)
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


initialUserInput : String
initialUserInput =
    "| one   | two  |\n|-------|------|\n| three | four |"


init : Model
init =
    update
        (Input initialUserInput)
        { userInput = initialUserInput
        , tableRows = []
        }


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
view ({ userInput } as model) =
    div
        [ class "container" ]
        [ div
            [ class "header"
            ]
            [ h1 [] [ text "Table Converter" ]
            ]
        , div
            [ class "top-panel"
            ]
            []
        , div
            [ class "table-container"
            ]
            [ tableView model.tableRows
            ]
        , div
            [ class "input-container"
            ]
            [ inputView userInput (UserInputToTable.errors userInput)
            ]
        , div
            [ class "bottom-panel"
            ]
            []
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


inputView : UserInput -> Maybe UserInputErr -> Html Msg
inputView userInput userInputErr =
    div
        [ class "textarea-container"
        ]
        [ div
            [ class "textarea-backdrop"
            ]
            [ div
                [ class "textarea-highlights"
                ]
                (case userInputErr of
                    Just { lines } ->
                        List.map
                            (\line ->
                                div
                                    [ class "textarea-highlight"
                                    , style "top" (String.fromInt (line - 1) ++ "rem")
                                    ]
                                    []
                            )
                            lines

                    Nothing ->
                        []
                )
            ]
        , textarea
            [ value userInput
            , onInput Input
            ]
            []
        , case userInputErr of
            Just { err } ->
                div
                    [ class "red" ]
                    [ text err ]

            Nothing ->
                text ""
        ]
