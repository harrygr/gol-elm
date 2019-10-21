module Main exposing (..)

import Html exposing (Html, text, div, h1, img, span)
import Html.Attributes exposing (src, style, class)


---- MODEL ----


type alias Model =
    List (List Int)


init : ( Model, Cmd Msg )
init =
    ( [ [ 1, 0, 0, 1, 0 ], [ 1, 0, 0, 1, 1 ], [ 1, 0, 0, 0, 0 ], [ 1, 0, 0, 0, 0 ], [ 0, 0, 1, 0, 0 ] ], Cmd.none )



---- UPDATE ----


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div [ class "container" ] (renderGrid model)


renderGrid grid =
    List.map renderRow grid


renderRow row =
    div [ class "row" ] (List.map renderCell row)


renderCell a =
    case a of
        1 ->
            div [ class "cell alive" ] []

        _ ->
            div [ class "cell dead" ] []



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
