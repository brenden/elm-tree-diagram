module Main exposing (..)

import Color exposing (..)
import Collage exposing (..)
import Element exposing (..)
import Text exposing (..)
import TreeDiagram exposing (drawCollage, node, Tree, defaultTreeLayout)


type Color
  = Red
  | Black



-- Tree to draw


redBlackTree =
  node
    (Just ( 13, Black ))
    [ node
        (Just ( 8, Red ))
        [ node
            (Just ( 1, Black ))
            [ node Nothing []
            , node
                (Just ( 6, Red ))
                [ node Nothing []
                , node Nothing []
                ]
            ]
        , node
            (Just ( 11, Black ))
            [ node Nothing []
            , node Nothing []
            ]
        ]
    , node
        (Just ( 17, Red ))
        [ node
            (Just ( 15, Black ))
            [ node Nothing []
            , node Nothing []
            ]
        , node
            (Just ( 25, Black ))
            [ node
                (Just ( 22, Red ))
                [ node Nothing []
                , node Nothing []
                ]
            , node
                (Just ( 27, Red ))
                [ node Nothing []
                , node Nothing []
                ]
            ]
        ]
    ]


{-| Represent edges as arrows from parent to child
-}
drawEdge : ( Float, Float ) -> ( Float, Float ) -> Form
drawEdge ( x0, y0 ) ( x1, y1 ) =
  let
    arrowOffset =
      42

    xd =
      x1 - x0

    yd =
      y1 - y0

    theta =
      atan (yd / xd)

    rot =
      if xd > 0 then
        theta
      else
        pi + theta

    dist =
      sqrt (xd ^ 2 + yd ^ 2)

    scale =
      (dist - arrowOffset) / dist

    to =
      ( x0 + scale * xd, y0 + scale * yd )
  in
    group
      [ segment ( x0, y0 ) to |> traced treeLineStyle
      , arrow |> move to |> rotate rot
      ]


{-| Represent nodes as colored circles with the node value inside.
-}
drawNode : Maybe ( Int, Color ) -> Form
drawNode n =
  case n of
    Just ( n, c ) ->
      let
        color =
          case c of
            Red ->
              red

            Black ->
              black
      in
        group
          [ circle 27 |> filled color
          , circle 27 |> outlined treeLineStyle
          , toString n |> fromString |> style treeNodeStyle |> text |> moveY 4
          ]

    Nothing ->
      group
        [ rect 50 35 |> filled black
        , fromString "Nil" |> style treeNilStyle |> text |> moveY 2
        ]
        |> moveY 5



-- Text style for interior nodes


treeNodeStyle =
  { defaultStyle
    | color = white
    , height = Just 30
    , typeface = [ "Times New Roman", "serif" ]
  }



-- Text style for the nil leaf nodes


treeNilStyle =
  { defaultStyle | color = white, height = Just 20 }



-- Line style for the tree


treeLineStyle =
  { defaultLine | width = 2 }



-- Arrow to go on the ends of edges


arrow =
  polygon [ ( -1, 1 ), ( 1, 0 ), ( -1, -1 ), ( -0.5, 0 ) ] |> filled black |> scale 10


main =
  drawCollage
    { defaultTreeLayout | padding = 60, siblingDistance = 80 }
    drawNode
    drawEdge
    redBlackTree
