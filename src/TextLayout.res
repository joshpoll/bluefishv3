open Kiwi.Strength

let encoding = _ => <rect width="100" height="100" />

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
  ],
  glyphs: [
    {
      id: "courseName1",
      children: [],
      encoding: encoding,
    },
    {
      id: "courseName2",
      children: [],
      encoding: encoding,
    },
    {
      id: "courseName3",
      children: [],
      encoding: encoding,
    },
    {
      id: "courseNum1",
      children: [],
      encoding: encoding,
    },
    {
      id: "courseNum2",
      children: [],
      encoding: encoding,
    },
    {
      id: "courseNum3",
      children: [],
      encoding: encoding,
    },
    {
      id: "instructors1",
      children: [],
      encoding: encoding,
    },
    {
      id: "instructors2",
      children: [],
      encoding: encoding,
    },
    {
      id: "instructors3",
      children: [],
      encoding: encoding,
    },
    {
      id: "course1",
      children: [],
      encoding: encoding,
    },
    {
      id: "course2",
      children: [],
      encoding: encoding,
    },
    {
      id: "course3",
      children: [],
      encoding: encoding,
    },
  ],
}
