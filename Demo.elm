import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import String
import Text

import TreeLayout exposing (draw, Tree(..), TreeLayout)

main : Element
main = let
    coolTree = Tree 4 [
                 Tree 6 [
                   Tree 32 [],
                   Tree 32 []
                 ],
                 Tree 99 [],
                 Tree 42 [
                   Tree 24 [
                     Tree 11 [],
                     Tree 11 [],
                     Tree 32 []
                   ],
                   Tree 25 [],
                   Tree 26 []
                 ],
                 Tree 88 [
                   Tree 999 [],
                   Tree 888 []
                 ],
                 Tree 42 [
                   Tree 23 [],
                   Tree 23 [],
                   Tree 24 [
                     Tree 11 [],
                     Tree 32 []
                   ],
                   Tree 25 [
                     Tree 22 []
                   ]
                 ]
               ]
  in
    draw 60 120 TreeLayout.TopToBottom 80 drawPoint drawLine coolTree

medGray = rgb 100 100 100
white = rgb 255 255 25

drawLine from to = segment from to |> traced (solid medGray)
drawPoint n = group [circle 16 |> filled medGray,
  text <| Text.color white <| intToText n]

intToText n = toString n |> Text.fromString
