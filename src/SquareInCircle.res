// Copy of Basalt's square-in-circle first example.
open Kiwi.Strength

let system = {
  KiwiGlyph.variables: [],
  constraints: [
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
    {
      lhs: AExpr(Var("canvas.width")),
      op: Eq,
      rhs: AExpr(Num(500.)),
      strength: required,
    },
    {
      lhs: AExpr(Var("canvas.height")),
      op: Eq,
      rhs: AExpr(Num(500.)),
      strength: required,
    },
    // center circle
    {
      lhs: AExpr(Var("circle.centerX")),
      op: Eq,
      rhs: AExpr(Var("canvas.centerX")),
      strength: strong,
    },
    // center circle
    {
      lhs: AExpr(Var("circle.centerY")),
      op: Eq,
      rhs: AExpr(Var("canvas.centerY")),
      strength: strong,
    },
    // circle is a circle. TODO: find a better way to do fixed aspect ratios?
    {
      lhs: AExpr(Var("circle.width")),
      op: Eq,
      rhs: AExpr(Var("circle.height")),
      strength: required,
    },
    // circle width is half of canvas width
    {
      lhs: AExpr(Var("circle.width")),
      op: Eq,
      rhs: AExpr(Div(Var("canvas.width"), 2.)),
      strength: strong,
    },
    // center square
    {
      lhs: AExpr(Var("square.centerX")),
      op: Eq,
      rhs: AExpr(Var("circle.centerX")),
      strength: strong,
    },
    // center square
    {
      lhs: AExpr(Var("square.centerY")),
      op: Eq,
      rhs: AExpr(Var("circle.centerY")),
      strength: strong,
    },
    // square is a square
    {
      lhs: AExpr(Var("square.width")),
      op: Eq,
      rhs: AExpr(Var("square.height")),
      strength: required,
    },
    // circumscribe constraint
    {
      lhs: AExpr(Var("square.width")),
      op: Eq,
      rhs: AExpr(Mul(Var("circle.width"), sqrt(2.) /. 2.)),
      strength: strong,
    },
  ],
  glyphs: [
    {
      // TODO: make this a built-in?
      id: "canvas",
      children: ["circle"],
      encoding: _ => <> </>,
    },
    {
      id: "square",
      children: [],
      encoding: ({left, top, width, height}) =>
        <rect
          x={Js.Float.toString(left)}
          y={Js.Float.toString(top)}
          width={Js.Float.toString(width)}
          height={Js.Float.toString(height)}
          style={ReactDOM.Style.make(~fillOpacity="0", ~stroke="#ff0000", ~strokeWidth="3", ())}
        />,
    },
    {
      id: "circle",
      children: ["square"],
      encoding: ({centerX, centerY, width, height}) =>
        <ellipse
          cx={Js.Float.toString(centerX)}
          cy={Js.Float.toString(centerY)}
          rx={Js.Float.toString(width /. 2.)}
          ry={Js.Float.toString(height /. 2.)}
          style={ReactDOM.Style.make(~stroke="#0000ff", ~fillOpacity="0", ~strokeWidth="3", ())}
        />,
    },
  ],
}
