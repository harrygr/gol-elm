module Model exposing (Model, Msg(..), freshModel, update)

import Grid exposing (Grid)
import Helpers exposing (evolve, toggle, buildGrid)


type alias Model =
    { grid : Grid Int, size: (Int, Int), evolving: Bool }

type Msg
    = NoOp
    | Evolve
    | Toggle ( Int, Int )
    | SetWidth String
    | SetHeight String
    | ToggleEvolving
    | Reset


freshModel : (Int, Int) -> ( Model, Cmd Msg )
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

        SetWidth width ->
            let
                currentSize = model.size
                currentWidth = Tuple.first(currentSize)
                newWidth = String.toInt width |> Maybe.withDefault(currentWidth)
                height = Tuple.second(currentSize)
            in
            ( { model | size = (newWidth, height), grid = buildGrid currentSize}, Cmd.none )

        SetHeight height ->
            let
                currentSize = model.size
                currentHeight = Tuple.second(currentSize)
                newHeight = String.toInt height |> Maybe.withDefault(currentHeight)
                width = Tuple.first(currentSize)
            in
            ( { model | size = (width, newHeight), grid = buildGrid currentSize}, Cmd.none )

        ToggleEvolving -> ({ model | evolving = not model.evolving }, Cmd.none)

        _ ->
            ( model, Cmd.none )
