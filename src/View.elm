module View exposing (view)

import Grid exposing (Grid)
import Html exposing (Html, button, div, input, label, span, text)
import Html.Attributes exposing (class, placeholder, type_, value, selected)
import Html.Events exposing (onClick, onInput, onCheck)
import Model exposing (Msg(..), Model)
import Array exposing (Array)

view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Evolve ] [ text "next" ]
        , button [ onClick Reset ] [ text "reset" ]
        , label [] [
            input [ type_ "checkbox", selected model.evolving, onCheck (\_ -> ToggleEvolving) ] []
            , span [] [ text "Auto evolve"]
        ]
        , div []
            [ label []
                [ span [] [ text "Width" ]
                , input [ placeholder "width", onInput SetWidth, type_ "number", value <| String.fromInt(Tuple.first(model.size)) ] []
                ],
                label []
                [ span [] [ text "Height" ]
                , input [ placeholder "height", onInput SetHeight, type_ "number", value <| String.fromInt(Tuple.second(model.size)) ] []
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