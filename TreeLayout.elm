module TreeLayout (layout, main) where

import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)

type Tree a = Node a | Subtree (List (Tree a))

type alias Coords = (Int, Int)
type alias PointDrawer a = (a -> Form)
type alias LineDrawer = (Coords -> Coords -> Form)

layout : Tree a -> PointDrawer a -> LineDrawer -> Element
layout tree drawPoint drawLine = collage 500 500 [ngon 5 50
  |> filled (rgb 100 100 100)]

main : Element
main = layout (Node 123)
              (\x -> show x |> toForm)
              (\c1 c2 -> show (c1, c2) |> toForm)
