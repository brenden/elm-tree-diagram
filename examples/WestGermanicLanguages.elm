import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import String
import Text

import TreeLayout exposing (draw, Tree(..), TreeLayout)


-- Tree to draw
westGermanicLanguages =
  Tree "West Germanic" [
    Tree "Ingvaeonic" [
      Tree "Old Saxon" [
        Tree "Middle Low German" [
          Tree "Low German" []
        ]
      ],
      Tree "Anglo-Frisian" [
        Tree "Old English" [
          Tree "Middle English" [
            Tree "English" []
          ]
        ],
        Tree "Old Frisian" [
          Tree "Frisian" []
        ]
      ]
    ],
    Tree "Istvaeonic" [
      Tree "Old Dutch" [
        Tree "Middle Dutch" [
          Tree "Dutch" [],
          Tree "Afrikaans" []
        ]
      ]
    ],
    Tree "Irminonic" [
      Tree "Old High German" [
        Tree "Middle High German" [
          Tree "German" []
        ],
        Tree "Old Yiddish" [
          Tree "Yiddish" []
        ]
      ]
    ]
  ]


{-| Represent edges as straight lines.
-}
drawLine : (Float, Float) -> (Float, Float) -> Form
drawLine from to = segment from to |> traced (solid black)


{-| Represent nodes as white textboxes
-}
drawNode : String -> Form
drawNode n =
  Text.fromString n |> centered |> width 100 |> container 100 50 middle
    |> color white |> toForm


main : Element
main = let
    siblingDistance = 110
    levelHeight = 100
    padding = 80
  in
    draw siblingDistance
         levelHeight
         TreeLayout.TopToBottom
         padding
         drawNode
         drawLine
         westGermanicLanguages
