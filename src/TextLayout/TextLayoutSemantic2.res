/*
  GOAL:

  **semantic representation:**

  "instructors": Primitive(
[
	"Jackson & Satyanarayan",
	"Mueller",
	"Miller, Greenberg, Keane",
]
)

"name": Primitive(
[
	"Software Studio",
	"Engineering Interactive Technologies",
	"Principles and Practice of Assistive Technology",
]
)

"num": Primitive(
[
	"6.170",
	"6.810",
	"6.811",
]
)

"course" : Relation(
	["name", "num", "instructors"],
	[[0, 0, 0],
	 [1, 1, 1],
	 [2, 2, 2]]
)

"canvas" : Relation(
	["course", "course"],
	[[0, 1],
	 [1, 2]]
)
// OR
"canvas" : List("course", [0, 1, 2])

  **gestalt representation:**

  "instructors" : text
"name" : text
"num" : text
"course" : [
	// must be a pair of fields of the relation!
	("num", "name") => hAlignedGap,
	("name", "instructors") => vAlignedGap
]
// punning if there are only two fields
"canvas" : vAlignedGap
// contains relation automatically generated

 */
open Semantic2

let semanticSystem = Belt.Map.String.fromArray([
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
  (
    "course",
    Relation(
      [("name", "name"), ("num", "num"), ("instructors", "instructors")],
      [[0, 0, 0], [1, 1, 1], [2, 2, 2]],
    ),
  ),
  ("courses", Relation([("curr", "course"), ("next", "course")], [[0, 1], [1, 2]])),
  ("canvas", Relation([("courses_0", "courses"), ("courses_1", "courses")], [[0, 1]])),
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
        ("num", "name", GestaltRelation.hAlignedGap(Num(9.5), Bottom)),
        ("name", "instructors", GestaltRelation.vAlignedGap(Num(2.), Left)),
      ],
    ),
  ),
  (
    "courses",
    Gestalt(
      None,
      false,
      [("curr", "next", GestaltRelation.combine(GestaltRelation.vGap(Num(10.)), GestaltRelation.leftAlign))],
    ),
  ),
  ("canvas", Gestalt(None, false, [])),
])
