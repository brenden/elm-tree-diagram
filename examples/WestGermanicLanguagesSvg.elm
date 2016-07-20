module Main exposing (..)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import String
import TreeDiagram exposing (drawSvg, Tree, defaultTreeLayout)


node' =
  TreeDiagram.node



-- Tree to draw


westGermanicLanguages =
  node'
    "West Germanic"
    [ node'
        "Ingvaeonic"
        [ node'
            "Old Saxon"
            [ node'
                "Middle Low German"
                [ node' "Low German" []
                ]
            ]
        , node'
            "Anglo-Frisian"
            [ node'
                "Old English"
                [ node'
                    "Middle English"
                    [ node' "English" []
                    ]
                ]
            , node'
                "Old Frisian"
                [ node' "Frisian" []
                ]
            ]
        ]
    , node'
        "Istvaeonic"
        [ node'
            "Old Dutch"
            [ node'
                "Middle Dutch"
                [ node' "Dutch" []
                , node' "Afrikaans" []
                ]
            ]
        ]
    , node'
        "Irminonic"
        [ node'
            "Old High German"
            [ node'
                "Middle High German"
                [ node' "German" []
                ]
            , node'
                "Old Yiddish"
                [ node' "Yiddish" []
                ]
            ]
        ]
    ]


(=>) prop value =
  prop (toString value)


{-| Represent edges as straight lines.
-}
drawLine : ( Float, Float ) -> ( Float, Float ) -> Svg msg
drawLine ( sourceX, sourceY ) ( targetX, targetY ) =
  line
    [ x1 => sourceX, y1 => sourceY, x2 => targetX, y2 => targetY, stroke "black" ]
    []


{-| Represent nodes as white textboxes
-}
drawNode : String -> Svg msg
drawNode n =
  g
    []
    [ rect [ width => 100, height => 50, fill "white", transform "translate(-40 -30)" ] []
    , text' [ width => 100, textAnchor "middle" ] [ text n ]
    ]


main =
  drawSvg
    { defaultTreeLayout
      | siblingDistance = 110
      , subtreeDistance = 150
      , padding = 80
    }
    drawNode
    drawLine
    westGermanicLanguages
