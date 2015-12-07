module TreeLayout (draw, layout, Tree(Tree)) where

import Debug
import Graphics.Collage exposing (..)
import Graphics.Element exposing (..)

type Tree a = Tree a (List (Tree a))

type alias Coord = (Float, Float)
type alias Contour = List (Int, Int)
type alias PointDrawer a = a -> Form
type alias LineDrawer = Coord -> Coord -> Form
type alias PrelimPosition = {
  subtreeOffset: Int,
  rootOffset: Int }

draw : Int -> Int -> PointDrawer a -> LineDrawer -> Tree a -> Element
draw siblingDistance levelHeight drawPoint drawLine tree =
  collage 1000 1000 (drawInternal drawPoint
                                drawLine
                                (layout siblingDistance
                                        levelHeight
                                        tree))


drawInternal : PointDrawer a -> LineDrawer -> Tree (a, Coord) -> List Form
drawInternal drawPoint drawLine (Tree (v, coord) subtrees) = let
    subtreePositions = List.map (\ (Tree (_, position) _) -> position) subtrees
    rootDrawing = drawPoint v |> move coord
    edgeDrawings = List.map (drawLine coord) subtreePositions
  in
    List.append (rootDrawing::edgeDrawings)
                (List.concatMap (drawInternal drawPoint drawLine)
                                subtrees)


layout : Int -> Int -> Tree a -> Tree (a, Coord)
layout siblingDistance levelHeight tree =
  final 0 levelHeight 0 (prelim siblingDistance tree)


final : Int -> Int -> Int -> Tree (a, PrelimPosition) -> Tree (a, Coord)
final level levelHeight lOffset (Tree (v, prelimPosition) subtrees) = let
    finalPosition = (toFloat (lOffset + prelimPosition.rootOffset),
                     toFloat (-level * levelHeight))
    subtreePrelimPositions = List.map
      (\ (Tree (_, prelimPosition) _) -> prelimPosition)
      subtrees
    visited = List.map2
      (\ prelimPos subtree -> final (level + 1)
                                    levelHeight
                                    (lOffset + prelimPos.subtreeOffset)
                                    subtree)
      subtreePrelimPositions
      subtrees
  in
    Tree (v, finalPosition) visited


prelim : Int -> Tree a -> Tree (a, PrelimPosition)
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
    case ends <| List.map2 (,) updatedChildren childContours of

      -- The root of the current tree has children.
      Just ((lSubtree, lSubtreeContour), (rSubtree, rSubtreeContour)) ->
        let
          (Tree (_, lPrelimPos) _) = lSubtree
          (Tree (_, rPrelimPos) _) = rSubtree

          -- Calculate the position of the root, relative to the left bound of
          -- the current tree. Store this in the preliminary position for the
          -- current tree.
          prelimPos = {
            subtreeOffset = 0,
            rootOffset = rootOffset lPrelimPos rPrelimPos
          }

          -- Construct the contour description of the current tree.
          rootContour = (prelimPos.rootOffset, prelimPos.rootOffset)
          treeContour = rootContour::(buildContour lSubtreeContour
                                                   rSubtreeContour
                                                   rPrelimPos.subtreeOffset)
        in
          (Tree (val, prelimPos) updatedChildren, treeContour)

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
subtreeOffsets : Int -> List Contour -> List Int
subtreeOffsets siblingDistance contours = case List.head contours of
  Just c0 -> let
    coolList = List.scanl
        (\ c (aggContour, runningOffset) -> let
            offset = pairwiseSubtreeOffset siblingDistance aggContour c
          in
            (buildContour aggContour c offset, offset))
        (c0, 0)
        (List.drop 1 contours)
    in
      List.map (\ (_, runningOffset) -> runningOffset) coolList
  Nothing -> []

{-
  let
    relOffsets = List.map (uncurry <| pairwiseSubtreeOffset siblingDistance)
                          (overlappingPairs contours)
  in
    List.scanl (+) 0 relOffsets
-}

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
buildContour : Contour -> Contour -> Int -> Contour
buildContour lContour rContour rContourOffset = let
    lLength = List.length lContour
    rLength = List.length rContour
    combinedContour = List.map2 (\ (lFrom, lTo) (rFrom, rTo) ->
      (lFrom, rTo + rContourOffset)) lContour rContour
  in
    if lLength > rLength then
      List.append combinedContour (List.drop rLength lContour)
    else
      List.append combinedContour (List.map
        (\ (from, to) -> (from + rContourOffset, to + rContourOffset))
        (List.drop lLength rContour))


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
  Just tail -> List.map2 (,) list tail
  Nothing -> []
