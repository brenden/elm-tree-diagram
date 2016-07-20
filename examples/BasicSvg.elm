module Main exposing (..)

import Svg exposing (Svg, svg, circle, line, g, text', text)
import Svg.Attributes exposing (..)
import TreeDiagram exposing (drawSvg, node, Tree, defaultTreeLayout)


-- Tree to draw


coolTree : Tree Int
coolTree =
  node
    61
    [ node
        84
        [ node 22 []
        , node 38 []
        ]
    , node
        72
        [ node
            3
            [ node 59 []
            , node 29 []
            , node 54 []
            ]
        , node 25 []
        , node 49 []
        ]
    , node
        24
        [ node 2 []
        ]
    , node
        17
        [ node 26 []
        , node
            68
            [ node 13 []
            , node 36 []
            ]
        , node 86 []
        ]
    ]


(=>) prop value =
  prop (toString value)


{-| Represent edges as straight lines.
-}
drawLine : ( Float, Float ) -> ( Float, Float ) -> Svg msg
drawLine ( sourceX, sourceY ) ( targetX, targetY ) =
  line
    [ x1 => sourceX, y1 => sourceY, x2 => targetX, y2 => targetY, stroke "red" ]
    []


{-| Represent nodes as circles with the node value inside.
-}
drawNode : Int -> Svg msg
drawNode n =
  g
    []
    [ circle [ r "16", stroke "black", fill "white", cx "0", cy "0" ] []
    , text' [ transform "translate(-8 5)" ] [ text (toString n) ]
    ]


main =
  drawSvg defaultTreeLayout drawNode drawLine coolTree
