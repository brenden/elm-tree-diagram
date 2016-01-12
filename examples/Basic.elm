import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Text exposing (..)
import String

import TreeLayout exposing (draw, Tree(..), defaultTreeLayout)

-- Tree to draw
coolTree =
  Tree 61 [
    Tree 84 [
      Tree 22 [],
      Tree 38 []
    ],
    Tree 72 [
      Tree 3 [
        Tree 59 [],
        Tree 29 [],
        Tree 54 []
      ],
      Tree 25 [],
      Tree 49 []
    ],
    Tree 24 [
      Tree 2 []
    ],
    Tree 17 [
      Tree 26 [],
      Tree 68 [
        Tree 13 [],
        Tree 36 []
      ],
      Tree 86 []
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
