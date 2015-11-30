module TreeLayout (draw, main) where

import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)

type Tree a = Tree a (List (Tree a))

type alias Coord = (Int, Int)
type alias Contour = List (Int, Int)
type alias PointDrawer a = (a -> Form)
type alias LineDrawer = (Coord -> Coord -> Form)

draw : Tree a -> PointDrawer a -> LineDrawer -> Element
draw tree drawPoint drawLine = collage 500 500 [ngon 5 50
  |> filled (rgb 100 100 100)]

--layout : Int -> Int -> Tree a -> Tree (Coord, a)
--layout prelimLayout >> finalLayout <|

prelim : Int -> Tree a -> Tree ((a, Int))
prelim siblingDistance tree = prelimInternal siblingDistance tree |> fst

prelimInternal : Int -> Tree a -> (Tree (a, Int), Contours)
prelimInternal siblingDistance (Tree nodeVal children) = let

    -- Traverse each of the child trees, getting the positioned child tree as
    -- well as a description of its contours
    (visitedChildren, childContours) =
      List.map (prelimInternal siblingDistance)
               children |> List.unzip

    -- Calculate the position of the left bound of each subtree, relative to
    -- the leftmost subtree
    subtreeOffsets = calculateSubtreeOffsets siblingDistance childContours

    -- Calculate the position of each child node, relative to its parent
    childOffsets = calculateChildOffsets subtreeOffsets childContours

    -- Store the offsets in the child nodes
    offsetChildren = List.map (uncurry setOffset)
                              (List.zip (visitedChildren, childOffsets))

    -- Construct the contour description of the current subtree
    parentCountour = calculateContour subtreeOffsets childContours
  in
    (Tree (nodeVal, 0) offsetChildren, parentContour)


calculateSubtreeOffsets : Int -> List Contour-> List Int
calculateSubtreeOffsets siblingDistance contours = 

setOffset : Tree (a, Int) -> Int -> Tree (a, Int)
setOffset (Tree (v, _) children) offset = Tree (v, offset) children

overlappingPairs : List a -> List (a, a)
overlappingPairs List a::b::rest = (a, b)::(overlappingPairs b::rest)
overlappingPairs otherwise 

main : Element
main = draw (Tree 123 [])
            (\x -> show x |> toForm)
            (\c1 c2 -> show (c1, c2) |> toForm)
