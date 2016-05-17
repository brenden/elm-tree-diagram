module Main exposing (..)

import Color exposing (..)
import Collage exposing (..)
import Element exposing (..)
import Text exposing (..)
import TreeDiagram exposing (drawCollage, node, Tree, defaultTreeLayout)


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


{-| Represent edges as straight lines.
-}
drawLine : ( Float, Float ) -> ( Float, Float ) -> Form
drawLine from to =
  segment from to |> traced (solid black)


{-| Represent nodes as circles with the node value inside.
-}
drawNode : Int -> Form
drawNode n =
  group
    [ circle 16 |> filled white
    , circle 16 |> outlined defaultLine
    , toString n |> fromString |> Text.color black |> text
    ]


main =
  drawCollage defaultTreeLayout drawNode drawLine coolTree
