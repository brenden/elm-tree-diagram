module Main exposing (..)

import Color exposing (..)
import Collage exposing (..)
import Element exposing (..)
import String
import Text
import TreeDiagram exposing (drawCollage, node, Tree, defaultTreeLayout)


-- Tree to draw


westGermanicLanguages =
  node
    "West Germanic"
    [ node
        "Ingvaeonic"
        [ node
            "Old Saxon"
            [ node
                "Middle Low German"
                [ node "Low German" []
                ]
            ]
        , node
            "Anglo-Frisian"
            [ node
                "Old English"
                [ node
                    "Middle English"
                    [ node "English" []
                    ]
                ]
            , node
                "Old Frisian"
                [ node "Frisian" []
                ]
            ]
        ]
    , node
        "Istvaeonic"
        [ node
            "Old Dutch"
            [ node
                "Middle Dutch"
                [ node "Dutch" []
                , node "Afrikaans" []
                ]
            ]
        ]
    , node
        "Irminonic"
        [ node
            "Old High German"
            [ node
                "Middle High German"
                [ node "German" []
                ]
            , node
                "Old Yiddish"
                [ node "Yiddish" []
                ]
            ]
        ]
    ]


{-| Represent edges as straight lines.
-}
drawEdge : ( Float, Float ) -> ( Float, Float ) -> Form
drawEdge from to =
  segment from to |> traced (solid black)


{-| Represent nodes as white textboxes
-}
drawNode : String -> Form
drawNode n =
  Text.fromString n
    |> centered
    |> width 100
    |> container 100 50 middle
    |> color white
    |> toForm


main =
  drawCollage
    { defaultTreeLayout
      | siblingDistance = 110
      , subtreeDistance = 150
      , padding = 80
    }
    drawNode
    drawEdge
    westGermanicLanguages
