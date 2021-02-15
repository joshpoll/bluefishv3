// https://upload.wikimedia.org/wikipedia/commons/e/e8/Simple-bipartite-graph.svg

open Semantic3

let toMap = Belt.Map.String.fromArray

let semanticSystem = {
  open Glyph
  toMap([
    (
      "vertex",
      [
        Primitive("blue"),
        Primitive("blue"),
        Primitive("blue"),
        Primitive("blue"),
        Primitive("blue"),
        Primitive("green"),
        Primitive("green"),
        Primitive("green"),
        Primitive("green"),
      ],
    ),
    (
      "U",
      [
        Record(
          toMap([
            (
              "elems",
              Set([
                Ref("vertex", 0),
                Ref("vertex", 1),
                Ref("vertex", 2),
                Ref("vertex", 3),
                Ref("vertex", 4),
              ]),
            ),
          ]),
          toMap([
            (
              "sibling",
              [
                toMap([("curr", Ref("elems", 0)), ("next", Ref("elems", 1))]),
                toMap([("curr", Ref("elems", 1)), ("next", Ref("elems", 2))]),
                toMap([("curr", Ref("elems", 2)), ("next", Ref("elems", 3))]),
                toMap([("curr", Ref("elems", 3)), ("next", Ref("elems", 4))]),
              ],
            ),
          ]),
        ),
      ],
    ),
    (
      "V",
      [
        Record(
          toMap([
            (
              "elems",
              Set([Ref("vertex", 5), Ref("vertex", 6), Ref("vertex", 7), Ref("vertex", 8)]),
            ),
          ]),
          toMap([
            (
              "sibling",
              [
                toMap([("curr", Ref("elems", 0)), ("next", Ref("elems", 1))]),
                toMap([("curr", Ref("elems", 1)), ("next", Ref("elems", 2))]),
                toMap([("curr", Ref("elems", 2)), ("next", Ref("elems", 3))]),
              ],
            ),
          ]),
        ),
      ],
    ),
    (
      "bipartite_graph",
      [
        Record(
          toMap([
            (
              "elems",
              Set([
                Ref("vertex", 0),
                Ref("vertex", 1),
                Ref("vertex", 2),
                Ref("vertex", 3),
                Ref("vertex", 4),
                Ref("vertex", 5),
                Ref("vertex", 6),
                Ref("vertex", 7),
                Ref("vertex", 8),
              ]),
            ),
            ("U", Ref("U", 0)),
            ("V", Ref("V", 0)),
          ]),
          toMap([
            (
              "E",
              [
                // TODO: want U.elems and V.elems
                toMap([("from", Ref("elems", 0)), ("to", Ref("elems", 5))]),
                toMap([("from", Ref("elems", 1)), ("to", Ref("elems", 5))]),
                toMap([("from", Ref("elems", 1)), ("to", Ref("elems", 6))]),
                toMap([("from", Ref("elems", 2)), ("to", Ref("elems", 7))]),
                toMap([("from", Ref("elems", 2)), ("to", Ref("elems", 8))]),
                toMap([("from", Ref("elems", 3)), ("to", Ref("elems", 6))]),
                toMap([("from", Ref("elems", 4)), ("to", Ref("elems", 5))]),
                toMap([("from", Ref("elems", 4)), ("to", Ref("elems", 8))]),
              ],
            ),
          ]),
        ),
      ],
    ),
    ("canvas", [Record(toMap([("bipartite_graph", Ref("bipartite_graph", 0))]), toMap([]))]),
  ])
}

/* TODO!!! */
let semanticEncoding: Semantic3.semanticEncoding = {
  open Encoding
  toMap([
    (
      "annotation",
      (Primitive(Mark.text(ReactDOM.Style.make(~font="light 18px sans-serif", ()))), None, true),
    ),
    (
      "vertex",
      (
        Primitive(
          (color, {KiwiGlyph.centerX: centerX, centerY}) =>
            <circle
              r="10"
              cx={centerX->Js.Float.toString}
              cy={centerY->Js.Float.toString}
              style={ReactDOM.Style.make(~fill=color, ~stroke="black", ~strokeWidth="3px", ())}
            />,
        ),
        None,
        true,
      ),
    ),
    (
      "U",
      (
        Record(
          Some(
            Mark.rect(
              ReactDOM.Style.make(
                ~fill="blue",
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
          toMap([("sibling", ("curr", "next", GestaltRelation.vAlignedGap(Num(20.), CenterX)))]),
        ),
        None,
        false,
      ),
    ),
    (
      "V",
      (
        Record(
          Some(
            Mark.rect(
              ReactDOM.Style.make(
                ~fill="green",
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
          toMap([("sibling", ("curr", "next", GestaltRelation.vAlignedGap(Num(20.), CenterX)))]),
        ),
        None,
        false,
      ),
    ),
    (
      "bipartite_graph",
      (
        Record(
          None,
          toMap([]),
          [(["U"], ["V"], GestaltRelation.hAlignedGap(Num(100.), CenterY))],
          toMap([("E", ("from", "to", GestaltRelation.link))]),
        ),
        None,
        false,
      ),
    ),
    ("canvas", (Record(None, toMap([]), [], toMap([])), None, false)),
  ])
}
