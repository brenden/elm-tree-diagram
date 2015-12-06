module TreeLayout (draw, main) where

import Color exposing (..)
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)

type Tree a = Tree a (List (Tree a))

type alias Coord = (Int, Int)
type alias Contour = List (Int, Int)
type alias PointDrawer a = (a -> Form)
type alias LineDrawer = (Coord -> Coord -> Form)
type alias PrelimPosition = {
  subtreeOffset: Int,
  rootOffset: Int }

draw : Tree a -> PointDrawer a -> LineDrawer -> Element
draw tree drawPoint drawLine = collage 500 500 [ngon 5 50
  |> filled (rgb 100 100 100)]

--layout : Int -> Int -> Tree a -> Tree (Coord, a)
--layout prelimLayout >> finalLayout <|

prelim : Int -> Tree a -> Tree ((a, PrelimPosition))
prelim siblingDistance tree = prelimInternal siblingDistance tree |> fst

prelimInternal : Int -> Tree a -> (Tree (a, PrelimPosition), Contour)
prelimInternal siblingDistance (Tree val children) = let

    -- Traverse each of the subtrees, getting the positioned subtree as well as
    -- a description of its contours.
    visited = List.map (prelimInternal siblingDistance) children
    (subtrees, childContours) = List.unzip visited

    -- Calculate the position of the left bound of each subtree, relative to
    -- the left bound of the current tree.
    offsets = subtreeOffsets siblingDistance childContours

    -- Store the offset for each of the subtrees.
    updatedChildren = List.map2
      (\ (Tree (v, prelimPosition) children) offset ->
        Tree (v, { prelimPosition | subtreeOffset = offset }) children)
      subtrees
      offsets
  in
    case ends visited of

      -- The root of the current tree has children.
      Just ((lSubtree, lSubtreeContour), (rSubtree, rSubtreeContour)) ->
        let
          (Tree (_, lPrelimPosition) _) = lSubtree
          (Tree (_, rPrelimPosition) _) = rSubtree

          -- Calculate the position of the root, relative to the left bound of
          -- the current tree. Store this in the preliminary position for the
          -- current tree.
          prelimPosition = {
            subtreeOffset = 0,
            rootOffset = rootOffset lPrelimPosition rPrelimPosition
          }

          -- Construct the contour description of the current tree.
          currentTreeContour = buildContour lSubtreeContour
                                            rSubtreeContour
                                            rPrelimPosition.subtreeOffset
                                            prelimPosition.rootOffset
        in
          (Tree (val, prelimPosition) updatedChildren,
            currentTreeContour)

      -- The root of the current tree is a leaf node.
      Nothing ->
        (Tree (val, {subtreeOffset = 0, rootOffset = 0}) updatedChildren,
          [(0, 0)])


{-| Given the preliminary positions of leftmost and rightmost subtrees, this
    calculates the offset of the root (their parent) relative to the leftmost
    bound of the tree starting at the root.
-}
rootOffset : PrelimPosition -> PrelimPosition -> Int
rootOffset lPrelimPosition rPrelimPosition =
  (lPrelimPosition.subtreeOffset +
   rPrelimPosition.subtreeOffset +
   lPrelimPosition.rootOffset +
   rPrelimPosition.rootOffset) // 2


{-| Calculate how far each subtree should be offset from the left bound of the
    first (leftmost) subtree. Each subtree needs to be positioned so that it is
    exactly `siblingDistance` away from its neighbors.
-}
subtreeOffsets : Int -> List Contour-> List Int
subtreeOffsets siblingDistance contours =
  List.map (uncurry <| pairwiseSubtreeOffset siblingDistance)
           (overlappingPairs contours)


{-| Given two contours, calculate the offset of the second from the left bound
    of the first such that the two are separated by exactly `siblingDistance`.
-}
pairwiseSubtreeOffset : Int -> Contour -> Contour -> Int
pairwiseSubtreeOffset siblingDistance lContour rContour = let
    levelDistances = List.map2 (\ (_, lTo) (rFrom, _) -> lTo - rFrom)
                     lContour
                     rContour
  in
    case List.maximum levelDistances of
      Just separatingDistance -> separatingDistance + siblingDistance
      Nothing -> 0


{-| Construct a contour for a ree. This is done by combining together the
    contours of the leftmost and rightmost subtrees, and then adding the root
    at the top of the new contour.
-}
buildContour : Contour -> Contour -> Int -> Int -> Contour
buildContour lContour rContour rContourOffset rootOffset = let
    combinedContour = List.map2 (\ (lFrom, lTo) (rFrom, rTo) ->
      (lFrom, rTo + rContourOffset)) lContour rContour
  in
    (rootOffset, rootOffset)::combinedContour


{-| Create a tuple containing the first and last elements in a list

    ends [1, 2, 3, 4] == (1, 4)
-}
ends : List a -> Maybe (a, a)
ends list = let
    first = List.head list
    last = List.head <| List.reverse list
  in
    Maybe.map2 (\ a b -> (a, b)) first last


{-| Create a list that contains a tuple for each pair of adjacent elements in
    the original list.

    overlappingPairs [1, 2, 3, 4] == [(1, 2), (2, 3), (3, 4)]
-}
overlappingPairs : List a -> List (a, a)
overlappingPairs list = case List.tail list of
  Just tail -> List.map2 (\ a b -> (a, b)) list tail
  Nothing -> []


main : Element
main = draw (Tree 123 [])
            (\x -> show x |> toForm)
            (\c1 c2 -> show (c1, c2) |> toForm)
