open Kiwi.Strength

let encoding = (color, {KiwiGlyph.left: left, top, width, height}) =>
  <rect
    x={Js.Float.toString(left)}
    y={Js.Float.toString(top)}
    width={Js.Float.toString(width)}
    height={Js.Float.toString(height)}
    style={ReactDOM.Style.make(~fill=color, ~fillOpacity="0.3", ~stroke="black", ())}
  />

let system = {
  KiwiGlyph.variables: [
    {
      id: "numNameGap",
      varOpt: Suggest(9.5, strong),
    },
    {
      id: "nameInstrsGap",
      varOpt: Suggest(10., strong),
    },
    {
      id: "courseGap",
      varOpt: Suggest(10., strong),
    },
  ],
  constraints: Belt.Array.concatMany([
    // courseNum -> courseName
    [("courseNum1", "courseName1"), ("courseNum2", "courseName2"), ("courseNum3", "courseName3")]
    ->Belt.Array.map(GestaltRelation.hAlignedGap(Var("numNameGap"), Bottom))
    ->Belt.Array.concatMany,
    // courseName -> instructors
    [
      ("courseName1", "instructors1"),
      ("courseName2", "instructors2"),
      ("courseName3", "instructors3"),
    ]
    ->Belt.Array.map(GestaltRelation.vAlignedGap(Var("nameInstrsGap"), Left))
    ->Belt.Array.concatMany,
    // course list
    [("course1", "course2"), ("course2", "course3")]
    ->Belt.Array.map(GestaltRelation.vGap(Var("courseGap")))
    ->Belt.Array.concatMany,
    // TODO: there are several ways to encode this!! Effectively serves as course's alignment
    [("courseName1", "courseName2"), ("courseName2", "courseName3")]
    ->Belt.Array.map(GestaltRelation.leftAlign)
    ->Belt.Array.concatMany,
    // contains relations
    [("course1", "courseName1"), ("course1", "courseNum1"), ("course1", "instructors1")]
    ->Belt.Array.map(GestaltRelation.contains)
    ->Belt.Array.concatMany,
    [("course2", "courseName2"), ("course2", "courseNum2"), ("course2", "instructors2")]
    ->Belt.Array.map(GestaltRelation.contains)
    ->Belt.Array.concatMany,
    [("course3", "courseName3"), ("course3", "courseNum3"), ("course3", "instructors3")]
    ->Belt.Array.map(GestaltRelation.contains)
    ->Belt.Array.concatMany,
    [("canvas", "course1"), ("canvas", "course2"), ("canvas", "course3")]
    ->Belt.Array.map(GestaltRelation.contains)
    ->Belt.Array.concatMany,
    [
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
      // courseName sizes
      {
        lhs: AExpr(Var("courseName1.width")),
        op: Eq,
        rhs: AExpr(Num(137.02)),
        strength: required,
      },
      {
        lhs: AExpr(Var("courseName1.height")),
        op: Eq,
        rhs: AExpr(Num(20.81)),
        strength: required,
      },
      {
        lhs: AExpr(Var("courseName2.width")),
        op: Eq,
        rhs: AExpr(Num(318.75)),
        strength: required,
      },
      {
        lhs: AExpr(Var("courseName2.height")),
        op: Eq,
        rhs: AExpr(Num(20.81)),
        strength: required,
      },
      {
        lhs: AExpr(Var("courseName3.width")),
        op: Eq,
        rhs: AExpr(Num(408.81)),
        strength: required,
      },
      {
        lhs: AExpr(Var("courseName3.height")),
        op: Eq,
        rhs: AExpr(Num(20.81)),
        strength: required,
      },
      // courseNum sizes
      {
        lhs: AExpr(Var("courseNum1.width")),
        op: Eq,
        rhs: AExpr(Num(40.5)),
        strength: required,
      },
      {
        lhs: AExpr(Var("courseNum1.height")),
        op: Eq,
        rhs: AExpr(Num(20.81)),
        strength: required,
      },
      {
        lhs: AExpr(Var("courseNum2.width")),
        op: Eq,
        rhs: AExpr(Num(40.5)),
        strength: required,
      },
      {
        lhs: AExpr(Var("courseNum2.height")),
        op: Eq,
        rhs: AExpr(Num(20.81)),
        strength: required,
      },
      {
        lhs: AExpr(Var("courseNum3.width")),
        op: Eq,
        rhs: AExpr(Num(39.86)),
        strength: required,
      },
      {
        lhs: AExpr(Var("courseNum3.height")),
        op: Eq,
        rhs: AExpr(Num(20.81)),
        strength: required,
      },
      // instructors sizes (TODO: set actual values!!)
      {
        lhs: AExpr(Var("instructors1.width")),
        op: Eq,
        rhs: AExpr(Num(40.5)),
        strength: required,
      },
      {
        lhs: AExpr(Var("instructors1.height")),
        op: Eq,
        rhs: AExpr(Num(20.81)),
        strength: required,
      },
      {
        lhs: AExpr(Var("instructors2.width")),
        op: Eq,
        rhs: AExpr(Num(40.5)),
        strength: required,
      },
      {
        lhs: AExpr(Var("instructors2.height")),
        op: Eq,
        rhs: AExpr(Num(20.81)),
        strength: required,
      },
      {
        lhs: AExpr(Var("instructors3.width")),
        op: Eq,
        rhs: AExpr(Num(39.86)),
        strength: required,
      },
      {
        lhs: AExpr(Var("instructors3.height")),
        op: Eq,
        rhs: AExpr(Num(20.81)),
        strength: required,
      },
    ],
  ]),
  glyphs: [
    {
      id: "courseName1",
      children: [],
      encoding: encoding("black"),
    },
    {
      id: "courseName2",
      children: [],
      encoding: encoding("black"),
    },
    {
      id: "courseName3",
      children: [],
      encoding: encoding("black"),
    },
    {
      id: "courseNum1",
      children: [],
      encoding: encoding("red"),
    },
    {
      id: "courseNum2",
      children: [],
      encoding: encoding("red"),
    },
    {
      id: "courseNum3",
      children: [],
      encoding: encoding("red"),
    },
    {
      id: "instructors1",
      children: [],
      encoding: encoding("blue"),
    },
    {
      id: "instructors2",
      children: [],
      encoding: encoding("blue"),
    },
    {
      id: "instructors3",
      children: [],
      encoding: encoding("blue"),
    },
    {
      id: "course1",
      children: [],
      encoding: encoding("white"),
    },
    {
      id: "course2",
      children: [],
      encoding: encoding("white"),
    },
    {
      id: "course3",
      children: [],
      encoding: encoding("white"),
    },
    {
      id: "canvas",
      children: [],
      encoding: _ => <> </>,
    },
  ],
}
