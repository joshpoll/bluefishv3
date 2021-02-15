open Kiwi.Strength

let encoding = (color, {KiwiGlyph.left: left, top, width, height}) =>
  <rect
    x={Js.Float.toString(left)}
    y={Js.Float.toString(top)}
    width={Js.Float.toString(width)}
    height={Js.Float.toString(height)}
    style={ReactDOM.Style.make(~fill=color, ~fillOpacity="0.3", ~stroke="black", ())}
  />

let textEncoding = (text, style) => {
  ({KiwiGlyph.left: left, bottom}) => {
    <text x={left->Js.Float.toString} y={bottom->Js.Float.toString} style>
      {text->React.string}
    </text>
  }
}

let nodeEncoding = (radius, color) => {
  ({KiwiGlyph.centerX: centerX, centerY}) =>
    <circle
      r={radius->Js.Float.toString}
      cx={centerX->Js.Float.toString}
      cy={centerY->Js.Float.toString}
      style={ReactDOM.Style.make(
        ~fill=color,
        ~fillOpacity="0.3",
        ~stroke="black",
        ~strokeWidth="5",
        (),
      )}
    />
}

let nodeGestalt = (annotationSize, (node, annotation)) => [
  // center annotation
  {
    KiwiGlyph.lhs: AExpr(Var(j`${node}.centerX`)),
    op: Eq,
    rhs: AExpr(Var(j`${annotation}.centerX`)),
    strength: strong,
  },
  {
    lhs: AExpr(Var(j`${node}.centerY`)),
    op: Eq,
    rhs: AExpr(Var(j`${annotation}.centerY`)),
    strength: strong,
  },
  // annotation region (using tight le's)
  {
    lhs: AExpr(Var(j`${annotation}.width`)),
    op: Le,
    rhs: AExpr(Mul(Var(j`${node}.width`), sqrt(2.) /. 2. *. annotationSize)),
    strength: strong,
  },
  {
    lhs: AExpr(Var(j`${annotation}.width`)),
    op: Eq,
    rhs: AExpr(Mul(Var(j`${node}.width`), sqrt(2.) /. 2. *. annotationSize)),
    strength: weak,
  },
  {
    lhs: AExpr(Var(j`${annotation}.height`)),
    op: Le,
    rhs: AExpr(Mul(Var(j`${node}.height`), sqrt(2.) /. 2. *. annotationSize)),
    strength: strong,
  },
  {
    lhs: AExpr(Var(j`${annotation}.height`)),
    op: Eq,
    rhs: AExpr(Mul(Var(j`${node}.height`), sqrt(2.) /. 2. *. annotationSize)),
    strength: weak,
  },
]

// TODO: node encoding. should take a size and an annotation. Then scale the annotation to fit inside a box
// within the circle.

let system = {
  Gestalt2.variables: [
    {
      id: "siblingGap",
      varOpt: Suggest(10., strong),
    },
    {
      id: "dataChildGap",
      varOpt: Suggest(20., strong),
    },
  ],
  constraints: [
    // canvas position
    {
      lhs: AExpr(Var("canvas.left")),
      op: Eq,
      rhs: AExpr(Num(0.)),
      strength: required,
    },
    {
      lhs: AExpr(Var("canvas.top")),
      op: Eq,
      rhs: AExpr(Num(0.)),
      strength: required,
    },
  ],
  relations: [
    {
      // canvas children
      instances: [("canvas", "node0")],
      gestalt: GestaltRelation.contains,
    },
    {
      // node0 children
      instances: [("node0", "data0"), ("node0", "children0")],
      gestalt: GestaltRelation.contains,
    },
    // data0 children: []
    {
      // children0 children
      instances: [("children0", "node1"), ("children0", "node2")],
      gestalt: GestaltRelation.contains,
    },
    {
      // node1 children
      instances: [("node1", "data1"), ("node1", "children1")],
      gestalt: GestaltRelation.contains,
    },
    // data1 children: []
    // children1 children: []
    {
      // node2 children
      instances: [("node2", "data2"), ("node2", "children2")],
      gestalt: GestaltRelation.contains,
    },
    // data2 children: []
    // children2 children: []
    // data-children relations
    {
      instances: [("data0", "children0")],
      gestalt: GestaltRelation.vAlignedGap(Var("dataChildGap"), CenterX),
    },
    {
      instances: [("data1", "children1")],
      gestalt: GestaltRelation.vAlignedGap(Var("dataChildGap"), CenterX),
    },
    {
      instances: [("data2", "children2")],
      gestalt: GestaltRelation.vAlignedGap(Var("dataChildGap"), CenterX),
    },
    // sibling relations
    {
      instances: [("node1", "node2")],
      gestalt: GestaltRelation.hAlignedGap(Var("siblingGap"), Top),
    },
    // data0 connectors
    {
      instances: [("data0", "data1"), ("data0", "data2")],
      gestalt: GestaltRelation.link,
    },
  ],
  glyphs: [
    {
      id: "node0",
      padding: None,
      children: [], // "data0", "children0"
      encoding: _ => <> </>, // transparent
      fixedSize: false,
    },
    {
      id: "data0",
      padding: None,
      children: [],
      encoding: nodeEncoding(30., "black"),
      fixedSize: true,
    },
    {
      id: "children0",
      padding: None,
      children: [], // "elems0" set = {"node1", "node2"}
      encoding: _ => <> </>, // transparent
      fixedSize: false,
    },
    {
      id: "node1",
      padding: None,
      children: [], // "data1", "children1"
      encoding: _ => <> </>, // transparent/group
      fixedSize: false,
    },
    {
      id: "data1",
      padding: None,
      children: [],
      encoding: nodeEncoding(30., "black"),
      fixedSize: true,
    },
    {
      id: "children1",
      padding: None,
      children: [], // "elems1" set = {}
      encoding: _ => <> </>, // transparent/group
      fixedSize: false,
    },
    {
      id: "node2",
      padding: None,
      children: [], // "data1", "children1"
      encoding: _ => <> </>, // transparent/group
      fixedSize: false,
    },
    {
      id: "data2",
      padding: None,
      children: [],
      encoding: nodeEncoding(30., "black"),
      fixedSize: true,
    },
    {
      id: "children2",
      padding: None,
      children: [], // "elems1" set = {}
      encoding: _ => <> </>, // transparent/group
      fixedSize: false,
    },
    {
      id: "canvas",
      padding: None,
      children: [], // "node0"
      encoding: _ => <> </>,
      fixedSize: false,
    },
  ],
}
