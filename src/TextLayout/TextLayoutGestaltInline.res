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

let system = {
  Gestalt2.variables: [
    {
      id: "numNameGap",
      varOpt: Suggest(18., strong),
    },
    {
      id: "nameInstrsGap",
      varOpt: Suggest(4., strong),
    },
    {
      id: "courseGap",
      varOpt: Suggest(10., strong),
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
      // courseNum -> courseName
      instances: [
        ("courseNum1", "courseName1"),
        ("courseNum2", "courseName2"),
        ("courseNum3", "courseName3"),
      ],
      gestalt: GestaltRelation.hAlignedGap(Var("numNameGap"), Bottom),
    },
    {
      // courseName -> instructors
      instances: [
        ("courseName1", "instructors1"),
        ("courseName2", "instructors2"),
        ("courseName3", "instructors3"),
      ],
      gestalt: GestaltRelation.hAlignedGap(Var("nameInstrsGap"), Bottom),
    },
    {
      // course list
      instances: [("course1", "course2"), ("course2", "course3")],
      gestalt: GestaltRelation.vGap(Var("courseGap")),
    },
    {
      // TODO: there are several ways to encode this!! Effectively serves as course's alignment
      instances: [("course1", "course2"), ("course2", "course3")],
      gestalt: GestaltRelation.leftAlign,
    },
    {
      // course1 children
      instances: [
        ("course1", "courseName1"),
        ("course1", "courseNum1"),
        ("course1", "instructors1"),
      ],
      gestalt: GestaltRelation.contains,
    },
    {
      // course2 children
      instances: [
        ("course2", "courseName2"),
        ("course2", "courseNum2"),
        ("course2", "instructors2"),
      ],
      gestalt: GestaltRelation.contains,
    },
    {
      // course3 children
      instances: [
        ("course3", "courseName3"),
        ("course3", "courseNum3"),
        ("course3", "instructors3"),
      ],
      gestalt: GestaltRelation.contains,
    },
    {
      // canvas children
      instances: [("canvas", "course1"), ("canvas", "course2"), ("canvas", "course3")],
      gestalt: GestaltRelation.contains,
    },
  ],
  glyphs: [
    {
      id: "courseName1",
      padding: None,
      children: [],
      encoding: textEncoding(
        "Software Studio",
        ReactDOM.Style.make(~font="18px light sans-serif", ()),
      ),
      fixedSize: true,
    },
    {
      id: "courseName2",
      padding: None,
      children: [],
      encoding: textEncoding(
        "Engineering Interactive Technologies",
        ReactDOM.Style.make(~font="18px light sans-serif", ()),
      ),
      fixedSize: true,
    },
    {
      id: "courseName3",
      padding: None,
      children: [],
      encoding: textEncoding(
        "Principles and Practice of Assistive Technology",
        ReactDOM.Style.make(~font="bold 18px sans-serif", ()),
      ),
      fixedSize: true,
    },
    {
      id: "courseNum1",
      padding: None,
      children: [],
      encoding: textEncoding("6.170", ReactDOM.Style.make(~font="18px light sans-serif", ())),
      fixedSize: true,
    },
    {
      id: "courseNum2",
      padding: None,
      children: [],
      encoding: textEncoding("6.810", ReactDOM.Style.make(~font="18px light sans-serif", ())),
      fixedSize: true,
    },
    {
      id: "courseNum3",
      padding: None,
      children: [],
      encoding: textEncoding("6.811", ReactDOM.Style.make(~font="18px light sans-serif", ())),
      fixedSize: true,
    },
    {
      id: "instructors1",
      padding: None,
      children: [],
      encoding: textEncoding(
        "Jackson & Satyanarayan",
        ReactDOM.Style.make(~font="18px light sans-serif", ()),
      ),
      fixedSize: true,
    },
    {
      id: "instructors2",
      padding: None,
      children: [],
      encoding: textEncoding("Mueller", ReactDOM.Style.make(~font="18px light sans-serif", ())),
      fixedSize: true,
    },
    {
      id: "instructors3",
      padding: None,
      children: [],
      encoding: textEncoding(
        "Miller, Greenberg, Keane",
        ReactDOM.Style.make(~font="italic 16px serif", ()),
      ),
      fixedSize: true,
    },
    {
      id: "course1",
      padding: None,
      children: [],
      encoding: _ => <> </>,
      fixedSize: false,
    },
    {
      id: "course2",
      padding: None,
      children: [],
      encoding: _ => <> </>,
      fixedSize: false,
    },
    {
      id: "course3",
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
