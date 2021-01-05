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
      id: "nameGuide",
      varOpt: Suggest(50., strong),
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
  constraints: [
    // numNameGap
    {
      lhs: AExpr(Add(Var("courseNum1.right"), Var("numNameGap"))),
      op: Eq,
      rhs: AExpr(Var("courseName1.left")),
      strength: strong,
    },
    {
      lhs: AExpr(Add(Var("courseNum2.right"), Var("numNameGap"))),
      op: Eq,
      rhs: AExpr(Var("courseName2.left")),
      strength: strong,
    },
    {
      lhs: AExpr(Add(Var("courseNum3.right"), Var("numNameGap"))),
      op: Eq,
      rhs: AExpr(Var("courseName3.left")),
      strength: strong,
    },
    // numNameAlignment
    {
      lhs: AExpr(Var("courseNum1.bottom")),
      op: Eq,
      rhs: AExpr(Var("courseName1.bottom")),
      strength: strong,
    },
    {
      lhs: AExpr(Var("courseNum2.bottom")),
      op: Eq,
      rhs: AExpr(Var("courseName2.bottom")),
      strength: strong,
    },
    {
      lhs: AExpr(Var("courseNum3.bottom")),
      op: Eq,
      rhs: AExpr(Var("courseName3.bottom")),
      strength: strong,
    },
    // nameGuide
    {
      lhs: AExpr(Var("courseName1.left")),
      op: Eq,
      rhs: AExpr(Var("nameGuide")),
      strength: strong,
    },
    {
      lhs: AExpr(Var("courseName2.left")),
      op: Eq,
      rhs: AExpr(Var("nameGuide")),
      strength: strong,
    },
    {
      lhs: AExpr(Var("courseName3.left")),
      op: Eq,
      rhs: AExpr(Var("nameGuide")),
      strength: strong,
    },
    // nameInstrsGap
    {
      lhs: AExpr(Add(Var("courseName1.bottom"), Var("nameInstrsGap"))),
      op: Eq,
      rhs: AExpr(Var("instructors1.top")),
      strength: strong,
    },
    {
      lhs: AExpr(Add(Var("courseName2.bottom"), Var("nameInstrsGap"))),
      op: Eq,
      rhs: AExpr(Var("instructors2.top")),
      strength: strong,
    },
    {
      lhs: AExpr(Add(Var("courseName3.bottom"), Var("nameInstrsGap"))),
      op: Eq,
      rhs: AExpr(Var("instructors3.top")),
      strength: strong,
    },
    // nameInstrsAlignment
    {
      lhs: AExpr(Var("courseName1.left")),
      op: Eq,
      rhs: AExpr(Var("instructors1.left")),
      strength: strong,
    },
    {
      lhs: AExpr(Var("courseName2.left")),
      op: Eq,
      rhs: AExpr(Var("instructors2.left")),
      strength: strong,
    },
    {
      lhs: AExpr(Var("courseName3.left")),
      op: Eq,
      rhs: AExpr(Var("instructors3.left")),
      strength: strong,
    },
    // courseGap
    {
      lhs: AExpr(Add(Var("course1.bottom"), Var("courseGap"))),
      op: Eq,
      rhs: AExpr(Var("course2.top")),
      strength: strong,
    },
    {
      lhs: AExpr(Add(Var("course2.bottom"), Var("courseGap"))),
      op: Eq,
      rhs: AExpr(Var("course3.top")),
      strength: strong,
    },
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
      children: ["courseName1", "courseNum1", "instructors1"],
      encoding: encoding("white"),
    },
    {
      id: "course2",
      children: ["courseName2", "courseNum2", "instructors2"],
      encoding: encoding("white"),
    },
    {
      id: "course3",
      children: ["courseName3", "courseNum3", "instructors3"],
      encoding: encoding("white"),
    },
    {
      id: "canvas",
      children: ["course1", "course2", "course3"],
      encoding: _ => <> </>,
    },
  ],
}
