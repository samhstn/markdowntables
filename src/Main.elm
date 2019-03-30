module Main exposing (Model, Msg(..), init, inputToRows, main, update, view)

import Browser
import Html exposing (Html, div, h1, table, td, text, textarea, tr)
import Html.Attributes exposing (class, value)
import Html.Events exposing (onInput)


main =
    Browser.sandbox
        { init = init
        , update = update
        , view = view
        }


init : Model
init =
    "| one | two |\n| three | four |"


type Msg
    = NoOp
    | Input String


type alias Model =
    String


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        Input str ->
            str


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
            [ table [] (tableRows (inputToRows model))
            ]
        , div
            [ class "input-container"
            ]
            [ textarea
                [ value model
                , onInput Input
                ]
                []
            ]
        , div
            [ class "footer"
            ]
            [ div [] [ text "footer" ]
            ]
        ]


tableRows : List (List String) -> List (Html Msg)
tableRows =
    List.map (\row -> tr [] (tableColumns row))


tableColumns : List String -> List (Html Msg)
tableColumns =
    List.map (\column -> td [] [ text column ])


inputToRows : Model -> List (List String)
inputToRows model =
    String.trim model
        |> String.split "\n"
        |> List.filter (String.isEmpty >> not)
        |> List.map String.trim
        |> List.map
            (String.split "|"
                >> List.filter (String.isEmpty >> not)
                >> List.map String.trim
            )
