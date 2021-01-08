// Copy of Basalt's simple example. Actually even simpler than that one!
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
  ],
  glyphs: [
    {
      // TODO: make this a built-in?
      id: "canvas",
      children: ["square"],
      encoding: _ => <> </>,
      fixedSize: false,
    },
    {
      id: "square",
      children: ["circle"],
      encoding: ({left, top, width, height}) =>
        <rect
          x={Js.Float.toString(left)}
          y={Js.Float.toString(top)}
          width={Js.Float.toString(width)}
          height={Js.Float.toString(height)}
          style={ReactDOM.Style.make(~fill="#ff0000", ~stroke="#000000", ~strokeWidth="3", ())}
        />,
      fixedSize: false,
    },
    {
      id: "circle",
      children: [],
      encoding: ({centerX, centerY, width, height}) =>
        <ellipse
          cx={Js.Float.toString(centerX)}
          cy={Js.Float.toString(centerY)}
          rx={Js.Float.toString(width /. 2.)}
          ry={Js.Float.toString(height /. 2.)}
          style={ReactDOM.Style.make(~stroke="#0000ff", ~fillOpacity="0", ())}
        />,
      fixedSize: false,
    },
  ],
}
