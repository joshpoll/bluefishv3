// Tree Layout using Semantic3

open Semantic3

let toMap = Belt.Map.String.fromArray

let semanticSystem = {
  open Glyph
  toMap([
    ("annotation", [Primitive("MulExp"), Primitive("\"-\""), Primitive("num")]),
    (
      "data",
      [
        Record(toMap([("annotation", Ref("annotation", 0))]), toMap([])),
        Record(toMap([("annotation", Ref("annotation", 1))]), toMap([])),
        Record(toMap([("annotation", Ref("annotation", 2))]), toMap([])),
      ],
    ),
    (
      "children",
      [
        Record(
          toMap([("elems", Set([Ref("node", 1), Ref("node", 2)]))]),
          toMap([("sibling", [toMap([("curr", Ref("elems", 0)), ("next", Ref("elems", 1))])])]),
        ),
        Record(toMap([("elems", Set([]))]), toMap([("sibling", [])])),
        Record(toMap([("elems", Set([]))]), toMap([("sibling", [])])),
      ],
    ),
    (
      "node",
      [
        Record(toMap([("data", Ref("data", 0)), ("children", Ref("children", 0))]), toMap([])),
        Record(toMap([("data", Ref("data", 1)), ("children", Ref("children", 1))]), toMap([])),
        Record(toMap([("data", Ref("data", 2)), ("children", Ref("children", 2))]), toMap([])),
      ],
    ),
    ("canvas", [Record(toMap([("node", Ref("node", 0))]), toMap([]))]),
  ])
}

let semanticEncoding = {
  open Encoding
  toMap([
    ("annotation", (Primitive(Mark.text(ReactDOM.Style.make(~font="bold 18px sans-serif", ()))), true)),
    (
      "data",
      (
        Record(
          Some(
            Mark.rect(ReactDOM.Style.make(
                  ~fill="black",
                  ~fillOpacity="0.3",
                  // ~stroke="black",
                  // ~strokeWidth="3",
                  (),
                ), "")
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
          toMap([("sibling", ("curr", "next", GestaltRelation.hAlignedGap(Num(5.), Top)))]),
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
          [("data", "children", GestaltRelation.vAlignedGap(Num(5.), CenterX))],
          toMap([]),
        ),
        false,
      ),
    ),
    ("canvas", (Record(None, toMap([]), [], toMap([])), false)),
  ])
}
