module Main exposing (..)

import Array exposing (Array)
import Browser
import Grid exposing (Grid)
import Html exposing (Html, button, div, input, label, span, text)
import Html.Attributes exposing (class, placeholder, type_, value)
import Html.Events exposing (onClick, onInput)



---- MODEL ----


type alias Model =
    { grid : Grid Int, size : Int }


buildGrid size = Grid.repeat size size 0

init : Int -> ( Model, Cmd Msg )
init size =
    ( { size = size, grid = buildGrid size }, Cmd.none )



---- UPDATE ----


type Msg
    = NoOp
    | Evolve
    | Toggle ( Int, Int )
    | SetSize String
    | Reset


update : Msg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
update msg ( model, _ ) =
    case msg of
        Evolve ->
            ( { model | grid = evolve model.grid }, Cmd.none )

        Toggle coords ->
            ( { model | grid = toggle coords model.grid }, Cmd.none )

        Reset ->
            init model.size

        SetSize size ->
            let
                sizeInt = String.toInt size |> Maybe.withDefault model.size
            in
            ( { model | size = sizeInt, grid = buildGrid sizeInt}, Cmd.none )

        _ ->
            ( model, Cmd.none )


toggle : ( Int, Int ) -> Grid Int -> Grid Int
toggle coords grid =
    let
        toggled =
            grid
                |> Grid.get coords
                |> Maybe.map ((-) 1)
                |> Maybe.map abs
                |> Maybe.withDefault 0
    in
    Grid.set coords toggled grid


evolve : Grid Int -> Grid Int
evolve grid =
    Grid.indexedMap (processCell grid) grid


processCell : Grid Int -> Int -> Int -> Int -> Int
processCell grid x y isAlive =
    let
        c =
            countNeighbors grid x y
    in
    case isAlive of
        1 ->
            if c < 2 || c > 3 then
                0

            else
                1

        _ ->
            if c == 3 then
                1

            else
                0


countNeighbors : Grid Int -> Int -> Int -> Int
countNeighbors grid x y =
    let
        nw =
            Grid.get ( x - 1, y - 1 ) grid

        n =
            Grid.get ( x, y - 1 ) grid

        ne =
            Grid.get ( x + 1, y - 1 ) grid

        w =
            Grid.get ( x - 1, y ) grid

        e =
            Grid.get ( x + 1, y ) grid

        sw =
            Grid.get ( x - 1, y + 1 ) grid

        s =
            Grid.get ( x, y + 1 ) grid

        se =
            Grid.get ( x + 1, y + 1 ) grid

        neighbors : List (Maybe Int)
        neighbors =
            [ nw, n, ne, w, e, sw, s, se ]
    in
    neighbors
        |> List.map (Maybe.withDefault 0)
        |> List.sum



-- VIEW ----


view : ( Model, Cmd Msg ) -> Html Msg
view ( model, _ ) =
    div []
        [ button [ onClick Evolve ] [ text "next" ]
        , button [ onClick Reset ] [ text "reset" ]
        , div []
            [ label []
                [ span [] [ text "Size" ]
                , input [ placeholder "size", onInput SetSize, type_ "number", value <| String.fromInt model.size ] []
                ]
            ]
        , div
            [ class "container" ]
            (renderGrid model.grid)
        ]


renderGrid : Grid Int -> List (Html Msg)
renderGrid grid =
    grid
        |> Grid.indexedMap renderCell
        |> Grid.rows
        |> Array.map renderRow
        |> Array.toList


renderRow : Array (Html Msg) -> Html Msg
renderRow row =
    div [ class "row" ] (Array.toList row)


renderCell : Int -> Int -> Int -> Html Msg
renderCell x y a =
    case a of
        1 ->
            div [ class "cell alive", onClick (Toggle ( x, y )) ] []

        _ ->
            div [ class "cell dead", onClick (Toggle ( x, y )) ] []



---- PROGRAM ----


main =
    Browser.sandbox
        { view = view
        , init = init 50
        , update = update
        }
