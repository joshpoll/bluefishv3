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
        ~strokeWidth="2",
        (),
      )}
    />
}

let nodeGestalt = (annotationSize, (node, annotation)): Gestalt2.gestaltEncoding => {
  constraints: [
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
  ],
  connectors: [],
}

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
      instances: [("node1", "node2")],
      gestalt: GestaltRelation.hAlignedGap(Var("siblingGap"), Top),
    },
    {
      instances: [("data0", "children0")],
      gestalt: GestaltRelation.vAlignedGap(Var("dataChildGap"), CenterX),
    },
    {
      // node0 children
      instances: [("node0", "data0"), ("node0", "children0")],
      gestalt: GestaltRelation.contains,
    },
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
    {
      // children1 children
      instances: [],
      gestalt: GestaltRelation.contains,
    },
    {
      // node2 children
      instances: [("node2", "data2"), ("node2", "children2")],
      gestalt: GestaltRelation.contains,
    },
    {
      // children2 children
      instances: [],
      gestalt: GestaltRelation.contains,
    },
    {
      // canvas children
      instances: [("canvas", "node0")],
      gestalt: GestaltRelation.contains,
    },
    {
      // data0 children
      instances: [("data0", "annotation0")],
      gestalt: GestaltRelation.contains,
    },
    {
      // data0-annotation0 gestalt
      instances: [("data0", "annotation0")],
      gestalt: nodeGestalt(0.75),
    },
    {
      // data1 children
      instances: [("data1", "annotation1")],
      gestalt: GestaltRelation.contains,
    },
    {
      // data1-annotation1 gestalt
      instances: [("data1", "annotation1")],
      gestalt: nodeGestalt(0.75),
    },
    {
      // data2 children
      instances: [("data2", "annotation2")],
      gestalt: GestaltRelation.contains,
    },
    {
      // data2-annotation2 gestalt
      instances: [("data2", "annotation2")],
      gestalt: nodeGestalt(0.75),
    },
  ],
  glyphs: [
    {
      id: "data0",
      padding: None,
      children: [],
      encoding: nodeEncoding(10., "black"),
      // textEncoding("0", ReactDOM.Style.make(~font="bold 18px sans-serif", ())),
      fixedSize: true,
    },
    {
      id: "annotation0",
      padding: None,
      children: [],
      encoding: encoding("red"),
      // TODO: text scaling doesn't work correctly
      // textEncoding("0", ReactDOM.Style.make(~font="bold 18px sans-serif", ())),
      fixedSize: false,
    },
    {
      id: "data1",
      padding: None,
      children: [],
      encoding: nodeEncoding(10., "black"),
      fixedSize: true,
    },
    {
      id: "data2",
      padding: None,
      children: [],
      encoding: nodeEncoding(10., "black"),
      fixedSize: true,
    },
    {
      id: "annotation1",
      padding: None,
      children: [],
      encoding: encoding("blue"),
      // textEncoding("1", ReactDOM.Style.make(~font="bold 18px sans-serif", ())),
      fixedSize: false,
    },
    {
      id: "annotation2",
      padding: None,
      children: [],
      encoding: encoding("green"),
      // textEncoding("2", ReactDOM.Style.make(~font="bold 18px sans-serif", ())),
      fixedSize: false,
    },
    {
      id: "node0",
      padding: None,
      children: [],
      encoding: _ => <> </>,
      fixedSize: false,
    },
    {
      id: "children0",
      padding: None,
      children: [],
      encoding: _ => <> </>,
      fixedSize: false,
    },
    {
      id: "node1",
      padding: None,
      children: [],
      encoding: _ => <> </>,
      fixedSize: false,
    },
    {
      id: "children1",
      padding: None,
      children: [],
      encoding: _ => <> </>,
      fixedSize: false,
    },
    {
      id: "node2",
      padding: None,
      children: [],
      encoding: _ => <> </>,
      fixedSize: false,
    },
    {
      id: "children2",
      padding: None,
      children: [],
      encoding: _ => <> </>,
      fixedSize: false,
    },
    {
      id: "canvas",
      padding: None,
      children: [],
      encoding: _ => <> </>,
      fixedSize: false,
    },
  ],
}
