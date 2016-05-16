import Application exposing (init, update, view, subscriptions)
import Html.App as App

main : Program Never
main =
  App.program
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }



