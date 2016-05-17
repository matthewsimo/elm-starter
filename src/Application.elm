module Application exposing
  ( Model
  , init
  , update
  , view
  , subscriptions
  )

import Debug
import Html
import Task
import Random
import List exposing ( (::), map )
import Window exposing ( Size )
import Mouse exposing ( Position )
import Html exposing (..)
import Html.Events exposing (onClick, onMouseDown, onMouseUp)
import Html.Attributes exposing (style)

import Application.Colors exposing ( colors, getColor, randomColor )

type alias Model =
  { window: Size
  , mouse: Position
  , isMouseDown: Bool
  , color: String
  , colors: List String
  }


-- Init

startColor : String
startColor = "pink"


emptyModel : Model
emptyModel =
  { window = { width = 0, height = 0 }
  , mouse = { x = 0, y = 0 }
  , isMouseDown = False
  , color = startColor
  , colors = [startColor]
  }


init : Maybe String -> ( Model, Cmd Msg )
init initColor =
  let
    initModel = case initColor of
      Just initColor -> { emptyModel | color = initColor, colors = [initColor] }
      _ -> emptyModel
  in
  initModel ! [ initWindowSize ]


initWindowSize : Cmd Msg
initWindowSize =
  Task.perform (\_ -> Debug.crash "no window?")
    WindowResize
    Window.size


-- Update

type Msg
  = WindowResize Size
  | MouseMoves Position
  | RandomColor
  | NewColor Int
  | MouseDown
  | MouseUp

update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
  case action of

    RandomColor ->
      (model, Random.generate NewColor randomColor)


    NewColor color ->
      ({ model | color = ( getColor color )
               , colors = ( ( getColor color ) :: model.colors )}
      , Cmd.none)

    MouseDown ->
      ({ model | isMouseDown = True }, Cmd.none )

    MouseUp ->
      ({ model | isMouseDown = False }, Cmd.none )

    WindowResize size ->
      ({ model | window = size }, Cmd.none )

    MouseMoves position ->
      ({ model | mouse = position }, Cmd.none )



-- Subscriptions

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch [ Window.resizes WindowResize
            , Mouse.moves MouseMoves
            ]



-- View

view : Model -> Html Msg
view model =
  div
    [ onMouseDown MouseDown
    , onMouseUp MouseUp
    , style [ ("width", "100vw")
            , ("height", "100vh")
            , ("padding", "1rem")
            , ("backgroundColor", backgroundColor model )
            ]
    ]
    [ h1 [] [ text "Hello World" ]
    , ul [] [ li [] [ text (toString model.isMouseDown) ]
            , listItem ( toString model.mouse )
            , listItem (toString model.window)
            , li [] [ button [ onClick RandomColor ] [ text "Random" ] ]
            , listItem ("current: " ++ toString model.color)
            , li [] [ ol [] ( map listItem model.colors ) ]
            ]
    ]


listItem : String -> Html a
listItem string =
  li []  [ text string ]


backgroundColor : Model -> String
backgroundColor model =
  case model.isMouseDown of
    True -> model.color
    False -> "white"

