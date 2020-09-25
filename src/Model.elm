module Model exposing (Model, Msg(..), freshModel, update)

import Grid exposing (Grid)
import Helpers exposing (evolve, toggle, buildGrid)


type alias Model =
    { grid : Grid Int, size : Int, evolving: Bool }

type Msg
    = NoOp
    | Evolve
    | Toggle ( Int, Int )
    | SetSize String
    | ToggleEvolving
    | Reset


freshModel : Int -> ( Model, Cmd Msg )
freshModel size =
    ( { size = size, grid = buildGrid size, evolving = False }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Evolve ->
            ( { model | grid = evolve model.grid }, Cmd.none )

        Toggle coords ->
            ( { model | grid = toggle coords model.grid }, Cmd.none )

        Reset ->
            freshModel model.size

        SetSize size ->
            let
                sizeInt = String.toInt size |> Maybe.withDefault model.size
            in
            ( { model | size = sizeInt, grid = buildGrid sizeInt}, Cmd.none )

        ToggleEvolving -> ({ model | evolving = not model.evolving }, Cmd.none)

        _ ->
            ( model, Cmd.none )
