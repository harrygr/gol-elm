module Main exposing (..)


import Browser
import Time
import View exposing (view)
import Model exposing (Msg(..), Model, update, freshModel)

subscriptions : Model -> Sub Msg
subscriptions model =
    if model.evolving then
        Time.every 150 (\_ -> Evolve)
    else
        Sub.none

init : () -> ( Model, Cmd Msg )
init _ = freshModel (83, 40)

main =
    Browser.element
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
