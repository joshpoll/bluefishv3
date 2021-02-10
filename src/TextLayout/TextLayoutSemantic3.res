/*
  GOAL: Sort of like an ANF where everything is either primitive or a ref.
  Currently only broken by `Set`, but that could be changed in the future.
*/

open Semantic3

let toMap = Belt.Map.String.fromArray

let semanticSystem = {
  open Glyph
  toMap([
    (
      "instructors",
      [
        Primitive("Jackson & Satyanarayan"),
        Primitive("Mueller"),
        Primitive("Miller, Greenberg, Keane"),
      ],
    ),
    (
      "name",
      [
        Primitive("Software Studio"),
        Primitive("Engineering Interactive Technologies"),
        Primitive("Principles and Practice of Assistive Technology"),
      ],
    ),
    ("num", [Primitive("6.170"), Primitive("6.810"), Primitive("6.811")]),
    (
      "course",
      [
        Record(
          toMap([
            ("name", Ref("name", 0)),
            ("num", Ref("num", 0)),
            ("instructors", Ref("instructors", 0)),
          ]),
          toMap([]),
        ),
        Record(
          toMap([
            ("name", Ref("name", 1)),
            ("num", Ref("num", 1)),
            ("instructors", Ref("instructors", 1)),
          ]),
          toMap([]),
        ),
        Record(
          toMap([
            ("name", Ref("name", 2)),
            ("num", Ref("num", 2)),
            ("instructors", Ref("instructors", 2)),
          ]),
          toMap([]),
        ),
      ],
    ),
    (
      "courses",
      [
        Record(
          toMap([("elems", Set([Ref("course", 0), Ref("course", 1), Ref("course", 2)]))]),
          toMap([
            (
              "sibling",
              [
                toMap([("curr", Ref("elems", 0)), ("next", Ref("elems", 1))]),
                toMap([("curr", Ref("elems", 1)), ("next", Ref("elems", 2))]),
              ],
            ),
          ]),
        ),
      ],
    ),
    ("canvas", [Record(toMap([("courses", Ref("courses", 0))]), toMap([]))]),
  ])
}

let semanticEncoding = {
  open Encoding
  toMap([
    ("instructors", (Primitive(Mark.text(ReactDOM.Style.make(~font="italic 16px serif", ()))), true)),
    ("name", (Primitive(Mark.text(ReactDOM.Style.make(~font="bold 18px sans-serif", ()))), true)),
    ("num", (Primitive(Mark.text(ReactDOM.Style.make(~font="18px light sans-serif", ()))), true)),
    (
      "course",
      (
        Record(
          None,
          toMap([]),
          [
            (["num"], ["name"], GestaltRelation.hAlignedGap(Num(9.5), Bottom)),
            (["name"], ["instructors"], GestaltRelation.vAlignedGap(Num(2.), Left)),
          ],
          toMap([]),
        ),
        false,
      ),
    ),
    (
      "courses",
      (
        Record(
          None,
          toMap([]),
          [],
          toMap([
            (
              "sibling",
              (
                ["curr"],
                ["next"],
                GestaltRelation.combine(GestaltRelation.vGap(Num(10.)), GestaltRelation.leftAlign),
              ),
            ),
          ]),
        ),
        false,
      ),
    ),
    ("canvas", (Record(None, toMap([]), [], toMap([])), false)),
  ])
}
