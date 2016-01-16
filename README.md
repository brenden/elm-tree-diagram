# elm-tree-diagrams
This is an Elm package for drawing diagrams of trees. For positioning the
trees, it uses a modified version of the algorithm described in
[Tidier Drawings of Trees](http://emr.cs.iit.edu/~reingold/tidier-drawings.pdf).

## Usage
Here's the tree data structure we want to draw:

```elm
coolTree = Tree 1 [
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
drawEdge from to = segment from to |> traced (solid black)
```

Finally we call TreeDiagram.draw with our tree, node drawer, and edge drawer:

```elm
main = draw defaultTreeLayout drawNode drawEdge coolTree
```

This should produce the diagram below.
![Output of usage example](http://brenden.github.io/elm-tree-layout/example-tree-diagram.png)

The argument `defaultTreeLayout` contains some options for configuring the
layout of the tree. See the API section below for more details.

## Examples
  * [Basic Usage](http://brenden.github.io/elm-tree-layout/basic) ([source](https://github.com/brenden/elm-tree-layout/blob/master/examples/Basic.elm))
  * [West Germanic Languages](http://brenden.github.io/elm-tree-layout/west-germanic-languages) ([source](https://github.com/brenden/elm-tree-layout/blob/master/examples/WestGermanicLanguages.elm))
  * [Red-Black Tree](http://brenden.github.io/elm-tree-layout/red-black-tree) ([source](https://github.com/brenden/elm-tree-layout/blob/master/examples/RedBlackTree.elm))

## API

## Future work
