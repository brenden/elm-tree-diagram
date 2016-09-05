module Main exposing (..)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import String
import TreeDiagram exposing (Tree, defaultTreeLayout)
import TreeDiagram.Svg exposing (draw)


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
drawLine : ( Float, Float ) -> Svg msg
drawLine ( targetX, targetY ) =
    line
        [ x1 => 0, y1 => 0, x2 => targetX, y2 => targetY, stroke "black" ]
        []


{-| Represent nodes as white textboxes
-}
drawNode : String -> Svg msg
drawNode n =
    g
        []
        [ rect [ width => 100, height => 40, fill "white", transform "translate(-50,-20)" ] []
        , text' [ width => 100, textAnchor "middle" ] [ text n ]
        ]


main =
    draw
        { defaultTreeLayout
            | siblingDistance = 110
            , subtreeDistance = 150
            , padding = 80
        }
        drawNode
        drawLine
        westGermanicLanguages
