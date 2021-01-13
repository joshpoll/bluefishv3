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

type data = string
type field = string

type relation =
  | Primitive(array<data>)
  // TODO: could specialize to just binary relations
  // TODO: could generalize int in the case that the field could be anything (like with contains)
  | Relation(array<field>, array<array<int>>)

type semanticSystem = Belt.Map.String.t<relation>

let exampleSemanticSystem = Belt.Map.String.fromArray([
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
  ("canvas", Relation(["course", "course"], [[0, 1], [1, 2]])),
])

type glyph = (data, KiwiGlyph.bbox) => React.element
type group = KiwiGlyph.bbox => React.element

type gestalt = (field, field, GestaltRelation.gestaltRelation)

type encoding =
  // bool represents whether or not fixed size
  | Glyph(glyph, bool)
  | Gestalt(group, bool, array<gestalt>)

type gestaltSystem = Belt.Map.String.t<encoding>

let text = (style, text) => {
  ({KiwiGlyph.left: left, bottom}) => {
    <text x={left->Js.Float.toString} y={bottom->Js.Float.toString} style>
      {text->React.string}
    </text>
  }
}

let exampleGestaltSystem = Belt.Map.String.fromArray([
  ("instructors", Glyph(text(ReactDOM.Style.make(~font="italic 16px serif", ())), true)),
  ("name", Glyph(text(ReactDOM.Style.make(~font="18px light sans-serif", ())), true)),
  ("num", Glyph(text(ReactDOM.Style.make(~font="bold 18px sans-serif", ())), true)),
  (
    "course",
    Gestalt(
      _ => <> </>,
      false,
      [
        ("num", "name", GestaltRelation.hAlignedGap(Num(9.5), Bottom)),
        ("name", "instructors", GestaltRelation.vAlignedGap(Num(2.), Left)),
      ],
    ),
  ),
  (
    "canvas",
    Gestalt(
      _ => <> </>,
      false,
      [
        (
          "course",
          "course",
          GestaltRelation.combine(
            GestaltRelation.vGap(Var("courseGap")),
            GestaltRelation.leftAlign,
          ),
        ),
      ],
    ),
  ),
])
