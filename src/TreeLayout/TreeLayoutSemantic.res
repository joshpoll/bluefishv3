open Semantic

let semanticSystem = Belt.Map.String.fromArray([
  ("data", Primitive(["red", "green", "blue"])),
  ("children", Relation(["node", "node"], [[0, 1]])),
  ("node", Relation(["data", "children"], [[/* TODO!!! */]])),
  ("instructors", Primitive(["Jackson & Satyanarayan", "Mueller", "Miller, Greenberg, Keane"])),
  (
    "name",
    Primitive([
      "Software Studio",
      "Engineering Interactive Technologies",
      "Principles and Practice of Assistive Technology",
    ]),
  ),
  ("num", Primitive(["6.170", "6.810", "6.811"])),
  ("course", Relation(["name", "num", "instructors"], [[0, 0, 0], [1, 1, 1], [2, 2, 2]])),
  ("courses", Relation(["course", "course"], [[0, 1], [1, 2]])),
  ("canvas", Relation(["courses", "courses"], [[0, 1]])),
])

let gestaltEncoding = Belt.Map.String.fromArray([
  ("instructors", Glyph(text(ReactDOM.Style.make(~font="italic 16px serif", ())), true)),
  ("name", Glyph(text(ReactDOM.Style.make(~font="bold 18px sans-serif", ())), true)),
  ("num", Glyph(text(ReactDOM.Style.make(~font="18px light sans-serif", ())), true)),
  (
    "course",
    Gestalt(
      None,
      false,
      [
        // numbers denote position in tuple
        (1, 0, GestaltRelation.hAlignedGap(Num(9.5), Bottom)),
        (0, 2, GestaltRelation.vAlignedGap(Num(2.), Left)),
      ],
    ),
  ),
  (
    "courses",
    Gestalt(
      None,
      false,
      [(0, 1, GestaltRelation.combine(GestaltRelation.vGap(Num(10.)), GestaltRelation.leftAlign))],
    ),
  ),
  ("canvas", Gestalt(None, false, [])),
])
