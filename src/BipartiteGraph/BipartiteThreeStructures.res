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
      "graph",
      [
        Record(
          toMap([
            (
              "V",
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
          ]),
          toMap([
            (
              "E",
              [
                toMap([("from", Ref("V", 0)), ("to", Ref("V", 5))]),
                toMap([("from", Ref("V", 1)), ("to", Ref("V", 5))]),
                toMap([("from", Ref("V", 1)), ("to", Ref("V", 6))]),
                toMap([("from", Ref("V", 2)), ("to", Ref("V", 7))]),
                toMap([("from", Ref("V", 2)), ("to", Ref("V", 8))]),
                toMap([("from", Ref("V", 3)), ("to", Ref("V", 6))]),
                toMap([("from", Ref("V", 4)), ("to", Ref("V", 5))]),
                toMap([("from", Ref("V", 4)), ("to", Ref("V", 8))]),
              ],
            ),
          ]),
        ),
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
      "canvas",
      [
        Record(
          toMap([("graph", Ref("graph", 0)), ("U", Ref("U", 0)), ("V", Ref("V", 0))]),
          toMap([]),
        ),
      ],
    ),
  ])
}

/* TODO!!! */
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
            ({KiwiGlyph.left: left, top}) =>
              <rect
                width="60"
                height="20"
                x={left->Js.Float.toString}
                y={top->Js.Float.toString}
                style={ReactDOM.Style.make(~fillOpacity="0", ~stroke="black", ~strokeWidth="2", ())}
              />,
          ),
          toMap([]),
          [],
          toMap([]),
        ),
        true,
      ),
    ),
    (
      "children",
      (
        Record(
          None,
          toMap([]),
          [],
          toMap([("sibling", ("curr", "next", GestaltRelation.hAlignedGap(Num(10.), Top)))]),
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
          // TODO: desired, but need to implement some simple selection to do this
          // split string at `.` then feed the list of strings to some sort of selector function
          // `children` gets the `children` glyph
          // `elems` gets every element of the `elems` set in the `children` glyph
          // `data` gets every `data` corresponding to each `elems` glyph
          // desired: `children.elems.data`
          [
            (["data"], ["children"], GestaltRelation.vAlignedGap(Num(20.), CenterX)),
            (["data"], ["children", "elems", "data"], GestaltRelation.link),
          ],
          toMap([]),
        ),
        false,
      ),
    ),
    ("canvas", (Record(None, toMap([]), [], toMap([])), false)),
  ])
}
