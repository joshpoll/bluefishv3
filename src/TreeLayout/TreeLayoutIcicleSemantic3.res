// Tree Layout using Semantic3

open Semantic3

let toMap = Belt.Map.String.fromArray

let semanticSystem = {
  open Glyph
  toMap([
    (
      "annotation",
      [
        Primitive("number"),
        Primitive("PriExp"),
        Primitive("MulExp"),
        Primitive("AddExp"),
        Primitive("AddExp - plus"),
        Primitive("\"+\""),
        Primitive("MulExp"),
        Primitive("PriExp"),
        Primitive("PriExp - paren"),
        Primitive("\"(\""),
        Primitive("Exp"),
        Primitive("\")\""),
        Primitive("AddExp"),
        Primitive("MulExp"),
        Primitive("MulExp - times"),
        Primitive("MulExp"),
        Primitive("\"*\""),
        Primitive("PriExp"),
        Primitive("PriExp"),
        Primitive("number"),
        Primitive("number"),
        Primitive("Exp"),
        Primitive("AddExp"),
      ],
    ),
    (
      "data",
      [
        Record(toMap([("annotation", Ref("annotation", 0))]), toMap([])),
        Record(toMap([("annotation", Ref("annotation", 1))]), toMap([])),
        Record(toMap([("annotation", Ref("annotation", 2))]), toMap([])),
        Record(toMap([("annotation", Ref("annotation", 3))]), toMap([])),
        Record(toMap([("annotation", Ref("annotation", 4))]), toMap([])),
        Record(toMap([("annotation", Ref("annotation", 5))]), toMap([])),
        Record(toMap([("annotation", Ref("annotation", 6))]), toMap([])),
        Record(toMap([("annotation", Ref("annotation", 7))]), toMap([])),
        Record(toMap([("annotation", Ref("annotation", 8))]), toMap([])),
        Record(toMap([("annotation", Ref("annotation", 9))]), toMap([])),
        Record(toMap([("annotation", Ref("annotation", 10))]), toMap([])),
        Record(toMap([("annotation", Ref("annotation", 11))]), toMap([])),
        Record(toMap([("annotation", Ref("annotation", 12))]), toMap([])),
        Record(toMap([("annotation", Ref("annotation", 13))]), toMap([])),
        Record(toMap([("annotation", Ref("annotation", 14))]), toMap([])),
        Record(toMap([("annotation", Ref("annotation", 15))]), toMap([])),
        Record(toMap([("annotation", Ref("annotation", 16))]), toMap([])),
        Record(toMap([("annotation", Ref("annotation", 17))]), toMap([])),
        Record(toMap([("annotation", Ref("annotation", 18))]), toMap([])),
        Record(toMap([("annotation", Ref("annotation", 19))]), toMap([])),
        Record(toMap([("annotation", Ref("annotation", 20))]), toMap([])),
        Record(toMap([("annotation", Ref("annotation", 21))]), toMap([])),
        Record(toMap([("annotation", Ref("annotation", 22))]), toMap([])),
      ],
    ),
    (
      "children",
      [
        Record(toMap([("elems", Set([]))]), toMap([("sibling", [])])),
        Record(toMap([("elems", Set([Ref("node", 0)]))]), toMap([("sibling", [])])),
        Record(toMap([("elems", Set([Ref("node", 1)]))]), toMap([("sibling", [])])),
        Record(toMap([("elems", Set([Ref("node", 2)]))]), toMap([("sibling", [])])),
        Record(
          toMap([("elems", Set([Ref("node", 3), Ref("node", 5), Ref("node", 6)]))]),
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
        Record(toMap([("elems", Set([]))]), toMap([("sibling", [])])),
        Record(toMap([("elems", Set([Ref("node", 7)]))]), toMap([("sibling", [])])),
        Record(toMap([("elems", Set([Ref("node", 8)]))]), toMap([("sibling", [])])),
        Record(
          toMap([("elems", Set([Ref("node", 9), Ref("node", 10), Ref("node", 11)]))]),
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
        Record(toMap([("elems", Set([]))]), toMap([("sibling", [])])),
        Record(toMap([("elems", Set([Ref("node", 12)]))]), toMap([("sibling", [])])),
        Record(toMap([("elems", Set([]))]), toMap([("sibling", [])])),
        Record(toMap([("elems", Set([Ref("node", 13)]))]), toMap([("sibling", [])])),
        Record(toMap([("elems", Set([Ref("node", 14)]))]), toMap([("sibling", [])])),
        Record(
          toMap([("elems", Set([Ref("node", 15), Ref("node", 16), Ref("node", 17)]))]),
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
        Record(toMap([("elems", Set([Ref("node", 18)]))]), toMap([("sibling", [])])),
        Record(toMap([("elems", Set([]))]), toMap([("sibling", [])])),
        Record(toMap([("elems", Set([Ref("node", 20)]))]), toMap([("sibling", [])])),
        Record(toMap([("elems", Set([Ref("node", 19)]))]), toMap([("sibling", [])])),
        Record(toMap([("elems", Set([]))]), toMap([("sibling", [])])),
        Record(toMap([("elems", Set([]))]), toMap([("sibling", [])])),
        Record(toMap([("elems", Set([Ref("node", 22)]))]), toMap([("sibling", [])])),
        Record(toMap([("elems", Set([Ref("node", 4)]))]), toMap([("sibling", [])])),
      ],
    ),
    (
      "node",
      [
        Record(toMap([("data", Ref("data", 0)), ("children", Ref("children", 0))]), toMap([])),
        Record(toMap([("data", Ref("data", 1)), ("children", Ref("children", 1))]), toMap([])),
        Record(toMap([("data", Ref("data", 2)), ("children", Ref("children", 2))]), toMap([])),
        Record(toMap([("data", Ref("data", 3)), ("children", Ref("children", 3))]), toMap([])),
        Record(toMap([("data", Ref("data", 4)), ("children", Ref("children", 4))]), toMap([])),
        Record(toMap([("data", Ref("data", 5)), ("children", Ref("children", 5))]), toMap([])),
        Record(toMap([("data", Ref("data", 6)), ("children", Ref("children", 6))]), toMap([])),
        Record(toMap([("data", Ref("data", 7)), ("children", Ref("children", 7))]), toMap([])),
        Record(toMap([("data", Ref("data", 8)), ("children", Ref("children", 8))]), toMap([])),
        Record(toMap([("data", Ref("data", 9)), ("children", Ref("children", 9))]), toMap([])),
        Record(toMap([("data", Ref("data", 10)), ("children", Ref("children", 10))]), toMap([])),
        Record(toMap([("data", Ref("data", 11)), ("children", Ref("children", 11))]), toMap([])),
        Record(toMap([("data", Ref("data", 12)), ("children", Ref("children", 12))]), toMap([])),
        Record(toMap([("data", Ref("data", 13)), ("children", Ref("children", 13))]), toMap([])),
        Record(toMap([("data", Ref("data", 14)), ("children", Ref("children", 14))]), toMap([])),
        Record(toMap([("data", Ref("data", 15)), ("children", Ref("children", 15))]), toMap([])),
        Record(toMap([("data", Ref("data", 16)), ("children", Ref("children", 16))]), toMap([])),
        Record(toMap([("data", Ref("data", 17)), ("children", Ref("children", 17))]), toMap([])),
        Record(toMap([("data", Ref("data", 18)), ("children", Ref("children", 18))]), toMap([])),
        Record(toMap([("data", Ref("data", 19)), ("children", Ref("children", 19))]), toMap([])),
        Record(toMap([("data", Ref("data", 20)), ("children", Ref("children", 20))]), toMap([])),
        Record(toMap([("data", Ref("data", 21)), ("children", Ref("children", 21))]), toMap([])),
        Record(toMap([("data", Ref("data", 22)), ("children", Ref("children", 22))]), toMap([])),
      ],
    ),
    ("canvas", [Record(toMap([("node", Ref("node", 21))]), toMap([]))]),
  ])
}

let semanticEncoding = {
  open Encoding
  toMap([
    (
      "annotation",
      (Primitive(Mark.text(ReactDOM.Style.make(~font="light 18px sans-serif", ()))), true),
    ),
    (
      "data",
      (
        Record(
          Some(
            Mark.rect(
              ReactDOM.Style.make(
                ~fill="black",
                ~fillOpacity="0.1",
                // ~stroke="black",
                // ~strokeWidth="3",
                (),
              ),
              "",
            ),
          ),
          toMap([]),
          [],
          toMap([]),
        ),
        false,
      ),
    ),
    (
      "children",
      (
        Record(
          None,
          toMap([]),
          [],
          toMap([("sibling", (["curr"], ["next"], GestaltRelation.hAlignedGap(Num(5.), Top)))]),
        ),
        false,
      ),
    ),
    (
      "node",
      (
        Record(
          None,
          toMap([]),
          [(["data"], ["children"], GestaltRelation.vAlignedGap(Num(5.), CenterX))],
          toMap([]),
        ),
        false,
      ),
    ),
    ("canvas", (Record(None, toMap([]), [], toMap([])), false)),
  ])
}
