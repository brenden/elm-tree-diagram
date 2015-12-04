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

prelimInternal : Int -> Tree a -> (Tree (a, Int), Contour)
prelimInternal siblingDistance (Tree nodeVal children) = let

    -- Traverse each of the child trees, getting the positioned child tree as
    -- well as a description of its contours
    visited = List.map (prelimInternal siblingDistance) children
    (childTrees, childContours) = List.unzip visited

    -- Calculate the position of the left bound of each subtree, relative to
    -- the left bound of the current tree
    subtreeOffsets = calculateSubtreeOffsets siblingDistance childContours

    -- Store the offset for each subtree in the root node of the subtree
    offsetChildren = List.map (uncurry setSubtreeOffset)
                              (List.zip (childTrees, childOffsets))
  in
    case ends visited of
      Just ((lSubtree, lSubtreeContour), (rSubtree, rSubtreeContour)) ->
        let
          -- Calculate the position of the root, relative to the left bound of
          -- the current tree
          rootOffset = calculateRootOffset lSubtree rSubtree

          -- Construct the contour description of the current subtree
          parentContour = buildContour lSubtreeContour
                                       rSubtreeContour
                                       getSubtreeOffset <| rSubtree
                                       rootOffset
        in
          (Tree (nodeVal, 0) offsetChildren, parentContour)
      Nothing ->
        (Tree (nodeVal, 0) offsetChildren, parentContour)


{-| Calculate how far each subtree should be offset from the left bound of the
    first (leftmost) subtree. Each subtree needs to be positioned so that it's
    `siblingDistance` away from its neighbors.
-}
calculateSubtreeOffsets : Int -> List Contour-> List Int
calculateSubtreeOffsets siblingDistance contours =
  List.map (uncurry pairwiseOffset)
           (overlappingPairs contours)

pairwiseOffset : Contour -> Contour -> Int
pairwiseOffset lContour rContour = let
    levelDistances = List.map2 (\ (_, lTo) (rFrom, _) -> lTo - lFrom)
                     lContour
                     rContour
  in
    case List.maximum levelDistances of
      Just maximum -> maximum
      Nothing -> 0


{-|
-}
calculateRootOffset : Tree -> Tree -> Int


{-|
-}
buildContour : Contour -> Contour -> Int -> Int -> Contour
buildContour lContour rContour rContourOffset rootOffest = let


{-| Create a tuple containing the first and last elements in a list

    ends [1, 2, 3, 4] == (1, 4)
-}
ends : List a -> Maybe (a, a)
ends list = let
    first = List.head list
    last = List.head <| List.reverse list
  in
    Maybe.map2 (\ a b -> (a, b)) first last


{-| Get the last element from a list

    last [2, 4, 8] == 8
-}
last : List a -> a
last = List.head << List.reverse

{-| Create a list that contains a tuple for each pair of adjacent elements in
    the original list.

    overlappingPairs [1, 2, 3, 4] == [(1, 2), (2, 3), (3, 4)]
-}
overlappingPairs : List a -> List (a, a)
overlappingPairs list = case List.tail list of
  Just tail -> List.map2 (\ a b -> (a, b)) list tail
  Nothing -> []


{-| Set the offset value of the root node of the given tree.
-}
setOffset : Tree (a, Int) -> Int -> Tree (a, Int)
setOffset (Tree (v, _) children) offset = Tree (v, offset) children


main : Element
main = draw (Tree 123 [])
            (\x -> show x |> toForm)
            (\c1 c2 -> show (c1, c2) |> toForm)
