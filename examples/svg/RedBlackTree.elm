module Main exposing (..)

import Svg exposing (Svg, svg, circle, line, polygon, rect, g, text_, text)
import Svg.Attributes exposing (..)
import TreeDiagram exposing (node, Tree, defaultTreeLayout)
import TreeDiagram.Svg exposing (draw)


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


(=>) prop value =
    prop (toString value)


{-| Represent edges as arrows from parent to child
-}
drawEdge : ( Float, Float ) -> Svg msg
drawEdge ( x, y ) =
    let
        arrowOffset =
            42

        theta =
            atan (y / x)

        rot_ =
            if x > 0 then
                theta
            else
                pi + theta

        rot =
            (rot_ / (2 * pi)) * 360

        dist =
            sqrt (x ^ 2 + y ^ 2)

        scale =
            (dist - arrowOffset) / dist

        ( xTo, yTo ) =
            ( scale * x, scale * y )
    in
        g
            []
            [ line
                [ x1 => 0, y1 => 0, x2 => xTo, y2 => yTo, stroke "black", strokeWidth "2" ]
                []
            , g
                [ transform <|
                    "translate("
                        ++ (toString xTo)
                        ++ " "
                        ++ (toString yTo)
                        ++ ") "
                        ++ "rotate("
                        ++ (toString rot)
                        ++ ")"
                ]
                [ arrow ]
            ]


{-| Represent nodes as colored circles with the node value inside.
-}
drawNode : Maybe ( Int, Color ) -> Svg msg
drawNode n =
    case n of
        Just ( n, c ) ->
            let
                color =
                    case c of
                        Red ->
                            "#CC0000"

                        Black ->
                            "black"
            in
                g
                    []
                    [ circle [ r "27", stroke "black", strokeWidth "2", fill color, cx "0", cy "0" ] []
                    , text_ [ textAnchor "middle", fill "white", fontSize "30", fontFamily "\"Times New Roman\",serif", transform "translate(0,11)" ] [ text <| toString n ]
                    ]

        Nothing ->
            g
                []
                [ rect [ width "50", height "35", stroke "black", transform "translate(-25,-22)" ] []
                , text_ [ textAnchor "middle", fill "white", fontSize "20", transform "translate(0,4)", fontFamily "sans-serif" ] [ text "Nil" ]
                ]



-- Arrow to go on the ends of edges


arrow =
    polygon [ points "-10,10 10,0, -10,-10 -5,0" ] []


main =
    draw
        { defaultTreeLayout | padding = 60, siblingDistance = 80 }
        drawNode
        drawEdge
        redBlackTree
