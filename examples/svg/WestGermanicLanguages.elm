module Main exposing (..)

import Svg exposing (..)
import Svg.Attributes exposing (..)
import String
import TreeDiagram exposing (Tree, defaultTreeLayout)
import TreeDiagram.Svg exposing (draw)


node_ =
    TreeDiagram.node



-- Tree to draw


westGermanicLanguages =
    node_
        "West Germanic"
        [ node_
            "Ingvaeonic"
            [ node_
                "Old Saxon"
                [ node_
                    "Middle Low German"
                    [ node_ "Low German" []
                    ]
                ]
            , node_
                "Anglo-Frisian"
                [ node_
                    "Old English"
                    [ node_
                        "Middle English"
                        [ node_ "English" []
                        ]
                    ]
                , node_
                    "Old Frisian"
                    [ node_ "Frisian" []
                    ]
                ]
            ]
        , node_
            "Istvaeonic"
            [ node_
                "Old Dutch"
                [ node_
                    "Middle Dutch"
                    [ node_ "Dutch" []
                    , node_ "Afrikaans" []
                    ]
                ]
            ]
        , node_
            "Irminonic"
            [ node_
                "Old High German"
                [ node_
                    "Middle High German"
                    [ node_ "German" []
                    ]
                , node_
                    "Old Yiddish"
                    [ node_ "Yiddish" []
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
        , text_ [ width => 100, textAnchor "middle" ] [ text n ]
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
