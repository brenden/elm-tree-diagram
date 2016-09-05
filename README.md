# elm-tree-diagram
This is an Elm package for drawing diagrams of trees. For positioning the
trees it uses the approach described in [Tidier Drawings of Trees](http://emr.cs.iit.edu/~reingold/tidier-drawings.pdf).

## Usage
Here's the tree data structure we want to draw:

```elm
coolTree =
    node
        1
        [ node 2 []
        , node 3 []
        , node
            4
            [ node 5 []
            , node 6 []
            , node 7 []
            ]
        ]
```

We first define a function for drawing the tree nodes, which in this case each
contain an integer. We'll display each node as white text on a black circle.

```elm
drawNode n =
    group
        [ circle 16 |> filled black
        , toString n |> fromString |> Text.color white |> text
        ]
```

Then we define a function for drawing the edges between nodes.

```elm
drawEdge to =
    segment (0, 0) to |> traced (solid black)
```

Finally we call draw with our tree, node drawer, and edge drawer:

```elm
main =
    toHtml <|
        draw defaultTreeLayout drawNode drawEdge coolTree
```

This should produce the diagram below.

![Output of usage example](http://brenden.github.io/elm-tree-diagram/example-tree-diagram.png)

The argument `defaultTreeLayout` contains some options for configuring the
layout of the tree. See the API section below for more details.

## Examples
  * Basic Usage
    * [canvas](http://brenden.github.io/elm-tree-diagram/canvas/basic) ([source](https://github.com/brenden/elm-tree-diagram/blob/master/examples/canvas/Basic.elm))
    * [svg](http://brenden.github.io/elm-tree-diagram/svg/basic) ([source](https://github.com/brenden/elm-tree-diagram/blob/master/examples/svg/Basic.elm))
  * West Germanic Languages
    * [canvas](http://brenden.github.io/elm-tree-diagram/canvas/west-germanic-languages) ([source](https://github.com/brenden/elm-tree-diagram/blob/master/examples/canvas/WestGermanicLanguages.elm))
    * [svg](http://brenden.github.io/elm-tree-diagram/svg/west-germanic-languages) ([source](https://github.com/brenden/elm-tree-diagram/blob/master/examples/svg/WestGermanicLanguages.elm))
  * Red-Black Tree
    * [canvas](http://brenden.github.io/elm-tree-diagram/canvas/red-black-tree) ([source](https://github.com/brenden/elm-tree-diagram/blob/master/examples/canvas/RedBlackTree.elm))
    * [svg](http://brenden.github.io/elm-tree-diagram/svg/red-black-tree) ([source](https://github.com/brenden/elm-tree-diagram/blob/master/examples/svg/RedBlackTree.elm))

## API
### TreeDiagram.Canvas
```elm
draw : TreeLayout -> NodeDrawer a Form -> EdgeDrawer Form -> Tree a -> Element
```
Draws the tree as a canvas image using the provided functions for drawings nodes and edges.

### TreeDiagram.Svg
```elm
draw : TreeLayout -> NodeDrawer a (Svg msg) -> EdgeDrawer (Svg msg) -> Tree a -> Html msg
```
Draws the tree as an SVG using the provided functions for drawings nodes and edges.

### TreeDiagram
```elm
node : a -> List (Tree a) -> Tree a
```
Creates a tree of type `a` from a node value and a list of subtrees.

---
```elm
type alias NodeDrawer a format = a -> format
```
Alias for functions that draw nodes of type `a` in the given `format` (e.g. `Svg msg` or `Form`).

---
```elm
type alias EdgeDrawer format = Coord -> format
```
Alias for functions that draw edges between nodes in the given `format`.

---
```elm
type alias TreeLayout =
    { orientation : TreeOrientation
    , levelHeight : Int
    , subtreeDistance : Int
    , siblingDistance : Int
    , padding : Int
    }
```
Options for laying out the tree:
  * orientation: direction of the tree from root to leaves.
  * levelHeight: vertical distance between parent and child nodes.
  * subtreeDistance: horizontal distance between subtrees.
  * siblingDistance: horizontal distance between siblings. This is usually set
    below `subtreeDistance` to produce a clearer distinction between sibling
    nodes and non-siblings on the same level of the tree.
  * padding: amount of space to leave around the edges of the diagram.

---
```elm
leftToRight : TreeOrientation
rightToLeft : TreeOrientation
topToBottom : TreeOrientation
bottomToTop : TreeOrientation
```
Possible orientations of the tree from root to leaves.

---
```elm
defaultTreeLayout =
    { orientation = topToBottom
    , levelHeight = 100
    , siblingDistance = 50
    , subtreeDistance = 80
    , padding = 40
    }
```
A set of default values that should be modified to create your TreeLayout.

## Future work
* Add support for drawing trees with labeled edges
* Add support for trees with varied node sizes
* Implement some more algorithms for laying out the tree
