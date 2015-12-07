import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)
import TreeLayout exposing (draw, Tree(..))

main : Element
main = let
    coolTree = Tree 4 [
                 Tree 6 [],
                 Tree 99 [],
                 Tree 42 [
                  Tree 24 [],
                  Tree 25 [],
                  Tree 26 []
                 ],
                 Tree 42 [
                  Tree 23 [],
                  Tree 24 [],
                  Tree 25 [
                    Tree 1 [],
                    Tree 2 []
                  ]
                 ]
               ]
    drawLine _ _ = rect 5 5 |> filled (rgb 100 100 100)
    drawPoint n = show n |> toForm
  in
    draw 30 50 drawPoint drawLine coolTree
