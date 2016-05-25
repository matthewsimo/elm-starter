import App exposing (Model, init, update, view, subscriptions)
import Html.App

main : Program (Maybe String)
main =
  Html.App.programWithFlags
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }



