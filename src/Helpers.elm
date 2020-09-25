module Helpers exposing (buildGrid, evolve, toggle)

import Grid exposing (Grid)


buildGrid : Int -> Grid Int
buildGrid size = Grid.repeat size size 0

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