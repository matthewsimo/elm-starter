import Application exposing (Model, init, update, view, subscriptions)
import Html.App as App

main : Program (Maybe String)
main =
  App.programWithFlags
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }



