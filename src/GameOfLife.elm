module GameOfLife exposing (getNeighborhood, CellState)

import Basics exposing (max)
import Array exposing (fromList, get, slice, map, toList)


type alias CellState =
    Int


type alias Coords =
    ( Int, Int )



-- |> Enum.map(fn(row) -> Enum.slice(row, xs, xl)


sliceRow : List CellState -> Int -> Int -> List CellState
sliceRow row x y =
    row
        |> fromList
        |> slice x y
        |> toList


getNeighborhood : List (List CellState) -> Coords -> List (List CellState)
getNeighborhood universe ( x, y ) =
    let
        ( ys, yl ) =
            getBounds universe y

        ( xs, xl ) =
            let
                rowMaybe =
                    get 0 (fromList universe)
            in
                case rowMaybe of
                    Just row ->
                        getBounds row x

                    Nothing ->
                        ( 0, 0 )
    in
        universe
            |> fromList
            |> slice ys yl
            |> map sliceRow
            |> toList


getBounds : List a -> Int -> Coords
getBounds universe y =
    let
        start =
            max 0 (y - 1)
    in
        case y of
            0 ->
                ( start, 2 )

            _ ->
                ( start, max 3 ((List.length universe) - 1) )
