# elm-tree-diagrams
This is an Elm package for drawing diagrams of trees. For positioning the
trees, it uses a modified version of the algorithm described in
[Tidier Drawings of Trees](http://emr.cs.iit.edu/~reingold/tidier-drawings.pdf)

## Usage
Here's the tree data structure we want to draw:

```elm
coolTree =
  Tree 1 [
    Tree 2 [],
    Tree 3 [],
    Tree 4 [
      Tree 5 [],
      Tree 6 [],
      Tree 7 []
    ]
  ]
```

We first define a function for drawing the tree nodes, which in this case each
contain an integer. We'll display each node as white text on a black circle.

```elm
drawNode n =
  group [
    circle 16 |> filled black,
    toString n |> Text.fromString |> Text.color white |> text
  ]
```

Then we define a function for drawing the edges between nodes.

```elm
drawLine from to = segment from to |> traced (solid black)
```

Finally we call TreeDiagram.draw with our tree, node drawer, and edge drawer:

```elm
main = draw defaultTreeLayout drawNode drawLine coolTree
```

The argument defaultTreeLayout contains some options for configuring the
layout of the tree. See the API section below for more details.

## Examples

## API

## TODO
