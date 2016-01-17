import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import String
import Text

import TreeDiagram exposing (draw, Tree(..), defaultTreeLayout)

-- Tree to draw
westGermanicLanguages =
  Node "West Germanic" [
    Node "Ingvaeonic" [
      Node "Old Saxon" [
        Node "Middle Low German" [
          Node "Low German" []
        ]
      ],
      Node "Anglo-Frisian" [
        Node "Old English" [
          Node "Middle English" [
            Node "English" []
          ]
        ],
        Node "Old Frisian" [
          Node "Frisian" []
        ]
      ]
    ],
    Node "Istvaeonic" [
      Node "Old Dutch" [
        Node "Middle Dutch" [
          Node "Dutch" [],
          Node "Afrikaans" []
        ]
      ]
    ],
    Node "Irminonic" [
      Node "Old High German" [
        Node "Middle High German" [
          Node "German" []
        ],
        Node "Old Yiddish" [
          Node "Yiddish" []
        ]
      ]
    ]
  ]


{-| Represent edges as straight lines.
-}
drawEdge : (Float, Float) -> (Float, Float) -> Form
drawEdge from to = segment from to |> traced (solid black)


{-| Represent nodes as white textboxes
-}
drawNode : String -> Form
drawNode n =
  Text.fromString n |> centered |> width 100 |> container 100 50 middle
    |> color white |> toForm


main : Element
main = draw { defaultTreeLayout | siblingDistance = 110,
                                  subtreeDistance = 150,
                                  padding = 80 }
       drawNode
       drawEdge
       westGermanicLanguages
