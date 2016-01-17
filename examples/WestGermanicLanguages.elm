import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import String
import Text

import TreeLayout exposing (draw, Tree(..), defaultTreeLayout)

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
