import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Text exposing (..)
import String

import TreeDiagram exposing (draw, Tree(..), defaultTreeLayout)

-- Tree to draw
coolTree =
  Node 61 [
    Node 84 [
      Node 22 [],
      Node 38 []
    ],
    Node 72 [
      Node 3 [
        Node 59 [],
        Node 29 [],
        Node 54 []
      ],
      Node 25 [],
      Node 49 []
    ],
    Node 24 [
      Node 2 []
    ],
    Node 17 [
      Node 26 [],
      Node 68 [
        Node 13 [],
        Node 36 []
      ],
      Node 86 []
    ]
  ]


{-| Represent edges as straight lines.
-}
drawLine : (Float, Float) -> (Float, Float) -> Form
drawLine from to = segment from to |> traced (solid black)


{-| Represent nodes as circles with the node value inside.
-}
drawNode : Int -> Form
drawNode n =
  group [
    circle 16 |> filled white,
    circle 16 |> outlined defaultLine,
    toString n |> fromString |> Text.color black |> text
  ]


main : Element
main = draw defaultTreeLayout drawNode drawLine coolTree
