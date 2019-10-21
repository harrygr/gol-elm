module TestGameOfLife exposing (..)

import Test exposing (..)
import Expect
import GameOfLife exposing (getNeighborhood)


-- Check out http://package.elm-lang.org/packages/elm-community/elm-test/latest to learn more about testing in Elm!


universe : Array (Array GameOfLife.CellState)
universe =
    [ [ 0, 1, 0, 0 ], [ 0, 1, 0, 0 ], [ 0, 1, 0, 0 ], [ 0, 0, 0, 0 ] ]


gameoflife : Test
gameoflife =
    describe "Game Of Life"
        [ test "Getting the neighborhood of a cell" <|
            \_ ->
                Expect.equal (getNeighborhood universe ( 2, 3 )) [ [ 1, 0, 0 ], [ 1, 0, 0 ], [ 0, 0, 0 ] ]
        ]
