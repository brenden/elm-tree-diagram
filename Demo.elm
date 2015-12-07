import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import TreeLayout exposing (draw, Tree(..))

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
    drawLine from to = segment from to |> traced (solid (rgb 100 0 0))
    drawPoint n = show 0 |> toForm
  in
    draw 30 60 drawPoint drawLine coolTree
