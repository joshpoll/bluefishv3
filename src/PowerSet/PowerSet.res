// Jennifer Brennan's Power Set Diagram

open Semantic3

let toMap = Belt.Map.String.fromArray

let semanticSystem = {
  open Glyph
  toMap([
    (
      "subset",
      [
        Primitive("A"),
        Primitive("B"),
        Primitive("C"),
        Primitive("D"),
        Primitive("A+B"),
        Primitive("A+C"),
        Primitive("B+C"),
        Primitive("A+D"),
        Primitive("B+D"),
        Primitive("C+D"),
        Primitive("A+B+C"),
        Primitive("A+B+D"),
        Primitive("A+C+D"),
        Primitive("B+C+D"),
        Primitive("A+B+C+D"),
      ],
    ),
    (
      "subset-ranks",
      [
        Record(
          toMap([
            (
              "elems",
              Set([Ref("subset", 0), Ref("subset", 1), Ref("subset", 2), Ref("subset", 3)]),
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
        Record(
          toMap([
            (
              "elems",
              Set([
                Ref("subset", 4),
                Ref("subset", 5),
                Ref("subset", 6),
                Ref("subset", 7),
                Ref("subset", 8),
                Ref("subset", 9),
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
                toMap([("curr", Ref("elems", 4)), ("next", Ref("elems", 5))]),
              ],
            ),
          ]),
        ),
        Record(
          toMap([
            (
              "elems",
              Set([Ref("subset", 10), Ref("subset", 11), Ref("subset", 12), Ref("subset", 13)]),
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
        Record(toMap([("elems", Set([Ref("subset", 14)]))]), toMap([("sibling", [])])),
      ],
    ),
    (
      "subset-graph",
      [
        Record(
          toMap([
            (
              "elems",
              Set([
                Ref("subset-ranks", 0),
                Ref("subset-ranks", 1),
                Ref("subset-ranks", 2),
                Ref("subset-ranks", 3),
              ]),
            ),
            (
              "subsets",
              Set([
                Ref("subset", 0),
                Ref("subset", 1),
                Ref("subset", 2),
                Ref("subset", 3),
                Ref("subset", 4),
                Ref("subset", 5),
                Ref("subset", 6),
                Ref("subset", 7),
                Ref("subset", 8),
                Ref("subset", 9),
                Ref("subset", 10),
                Ref("subset", 11),
                Ref("subset", 12),
                Ref("subset", 13),
                Ref("subset", 14),
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
              ],
            ),
            (
              "subset-rel",
              [
                toMap([("a", Ref("subset", 0)), ("b", Ref("subset", 4))]),
                toMap([("a", Ref("subset", 0)), ("b", Ref("subset", 5))]),
                toMap([("a", Ref("subset", 0)), ("b", Ref("subset", 7))]),
                toMap([("a", Ref("subset", 1)), ("b", Ref("subset", 4))]),
                toMap([("a", Ref("subset", 1)), ("b", Ref("subset", 6))]),
                toMap([("a", Ref("subset", 1)), ("b", Ref("subset", 8))]),
                toMap([("a", Ref("subset", 2)), ("b", Ref("subset", 5))]),
                toMap([("a", Ref("subset", 2)), ("b", Ref("subset", 7))]),
                toMap([("a", Ref("subset", 2)), ("b", Ref("subset", 9))]),
                toMap([("a", Ref("subset", 3)), ("b", Ref("subset", 7))]),
                toMap([("a", Ref("subset", 3)), ("b", Ref("subset", 8))]),
                toMap([("a", Ref("subset", 3)), ("b", Ref("subset", 9))]),
                toMap([("a", Ref("subset", 4)), ("b", Ref("subset", 10))]),
                toMap([("a", Ref("subset", 4)), ("b", Ref("subset", 11))]),
                toMap([("a", Ref("subset", 5)), ("b", Ref("subset", 10))]),
                toMap([("a", Ref("subset", 5)), ("b", Ref("subset", 12))]),
                toMap([("a", Ref("subset", 6)), ("b", Ref("subset", 10))]),
                toMap([("a", Ref("subset", 6)), ("b", Ref("subset", 13))]),
                toMap([("a", Ref("subset", 7)), ("b", Ref("subset", 11))]),
                toMap([("a", Ref("subset", 7)), ("b", Ref("subset", 12))]),
                toMap([("a", Ref("subset", 8)), ("b", Ref("subset", 11))]),
                toMap([("a", Ref("subset", 8)), ("b", Ref("subset", 13))]),
                toMap([("a", Ref("subset", 9)), ("b", Ref("subset", 12))]),
                toMap([("a", Ref("subset", 9)), ("b", Ref("subset", 13))]),
                toMap([("a", Ref("subset", 10)), ("b", Ref("subset", 14))]),
                toMap([("a", Ref("subset", 11)), ("b", Ref("subset", 14))]),
                toMap([("a", Ref("subset", 12)), ("b", Ref("subset", 14))]),
                toMap([("a", Ref("subset", 13)), ("b", Ref("subset", 14))]),
              ],
            ),
          ]),
        ),
      ],
    ),
    ("canvas", [Record(toMap([("subset-graph", Ref("subset-graph", 0))]), toMap([]))]),
  ])
}

/* TODO!!! */
let semanticEncoding: Semantic3.semanticEncoding = {
  open Encoding
  toMap([
    (
      "subset",
      (Primitive(Mark.text(ReactDOM.Style.make(~font="light 18px sans-serif", ()))), None, true),
    ),
    // (
    //   "vertex",
    //   (
    //     Primitive(
    //       (color, {KiwiGlyph.centerX: centerX, centerY}) =>
    //         <circle
    //           r="10"
    //           cx={centerX->Js.Float.toString}
    //           cy={centerY->Js.Float.toString}
    //           style={ReactDOM.Style.make(~fill=color, ~stroke="black", ~strokeWidth="3px", ())}
    //         />,
    //     ),
    //     None,
    //     true,
    //   ),
    // ),
    (
      "subset-ranks",
      (
        Record(
          None,
          toMap([]),
          [],
          toMap([("sibling", ("curr", "next", GestaltRelation.hAlignedGap(Num(20.), CenterY)))]),
        ),
        None,
        false,
      ),
    ),
    (
      "subset-graph",
      (
        Record(
          None,
          toMap([]),
          [],
          toMap([
            ("sibling", ("next", "curr", GestaltRelation.vAlignedGap(Num(20.), CenterX))),
            ("subset-rel", ("a", "b", GestaltRelation.link)),
          ]),
        ),
        None,
        false,
      ),
    ),
    ("canvas", (Record(None, toMap([]), [], toMap([])), None, false)),
  ])
}
