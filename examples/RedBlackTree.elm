import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import Text exposing (..)

import TreeLayout exposing (draw, Tree(..), defaultTreeLayout)

type Color = Red | Black

-- Tree to draw
redBlackTree =
  Tree (Just (13, Black)) [
    Tree (Just (8, Red)) [
      Tree (Just (1, Black)) [
        Tree Nothing [],
        Tree (Just (6, Red)) [
          Tree Nothing [],
          Tree Nothing []
        ]
      ],
      Tree (Just (11, Black)) [
        Tree Nothing [],
        Tree Nothing []
      ]
    ],
    Tree (Just (17, Red)) [
      Tree (Just (15, Black)) [
        Tree Nothing [],
        Tree Nothing []
      ],
      Tree (Just (25, Black)) [
        Tree (Just (22, Red)) [
          Tree Nothing [],
          Tree Nothing []
        ],
        Tree (Just (27, Red)) [
          Tree Nothing [],
          Tree Nothing []
        ]
      ]
    ]
  ]


{-| Represent edges as arrows from parent to child
-}
drawLine : (Float, Float) -> (Float, Float) -> Form
drawLine (x0, y0) (x1, y1) = let
    arrowOffset = 42
    xd = x1 - x0
    yd = y1 - y0
    theta = atan(yd / xd)
    rot = if xd > 0 then theta else pi + theta
    dist = sqrt (xd^2 + yd^2)
    scale = (dist - arrowOffset) / dist
    to = (x0 + scale * xd, y0 + scale * yd)
  in
    group [
      segment (x0, y0) to |> traced treeLineStyle,
      arrow |> move to |> rotate rot
    ]


{-| Represent nodes as colored circles with the node value inside.
-}
drawNode : Maybe (Int, Color) -> Form
drawNode n = case n of
  Just (n, c) -> let
      color = case c of
        Red -> red
        Black -> black
    in
      group [
        circle 27 |> filled color,
        circle 27 |> outlined treeLineStyle,
        toString n |> fromString |> style treeNodeStyle |> text |> moveY 4
      ]
  Nothing -> group [
    rect 50 35 |> filled black,
    fromString "Nil" |> style treeNilStyle |> text |> moveY 2
  ] |> moveY 5

-- Text style for interior nodes
treeNodeStyle = { defaultStyle | color = white,
                                 height = Just 30,
                                 typeface = ["Times New Roman", "serif"] }

-- Text style for the nil leaf nodes
treeNilStyle = { defaultStyle | color = white,
                                height = Just 20 }

-- Line style for the tree
treeLineStyle = { defaultLine | width = 2 }

-- Arrow to go on the ends of edges
arrow =
  polygon [(-1, 1), (1, 0), (-1, -1), (-0.5, 0)] |> filled black |> scale 10


main : Element
main = draw { defaultTreeLayout | padding = 60, siblingDistance = 80 }
            drawNode
            drawLine
            redBlackTree
