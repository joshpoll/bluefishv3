/*
  GOAL: Sort of like an ANF where everything is either primitive or a ref.
  Currently only broken by `Set`, but that could be changed in the future.
*/

// https://observablehq.com/@ericd9799/learning-stacked-bar-chart-in-d3-js

/*
category,yes,no,maybe
fruit,6,7,8
vegetable,5,4,9
protein,5,9,12
snack,10,13,12
 */

open Semantic3

let toMap = Belt.Map.String.fromArray

let semanticSystem = {
  open Glyph
  toMap([
    ("yes", [Primitive("6"), Primitive("5"), Primitive("5"), Primitive("10")]),
    ("no", [Primitive("7"), Primitive("4"), Primitive("9"), Primitive("13")]),
    ("maybe", [Primitive("8"), Primitive("9"), Primitive("12"), Primitive("12")]),
    (
      "category",
      [Primitive("fruit"), Primitive("vegetable"), Primitive("protein"), Primitive("snack")],
    ),
    (
      "counts",
      [
        Record(
          toMap([("yes", Ref("yes", 0)), ("no", Ref("no", 0)), ("maybe", Ref("maybe", 0))]),
          toMap([]),
        ),
        Record(
          toMap([("yes", Ref("yes", 1)), ("no", Ref("no", 1)), ("maybe", Ref("maybe", 1))]),
          toMap([]),
        ),
        Record(
          toMap([("yes", Ref("yes", 2)), ("no", Ref("no", 2)), ("maybe", Ref("maybe", 2))]),
          toMap([]),
        ),
        Record(
          toMap([("yes", Ref("yes", 3)), ("no", Ref("no", 3)), ("maybe", Ref("maybe", 3))]),
          toMap([]),
        ),
      ],
    ),
    (
      "entry",
      [
        Record(toMap([("category", Ref("category", 0)), ("counts", Ref("counts", 0))]), toMap([])),
        Record(toMap([("category", Ref("category", 1)), ("counts", Ref("counts", 1))]), toMap([])),
        Record(toMap([("category", Ref("category", 2)), ("counts", Ref("counts", 2))]), toMap([])),
        Record(toMap([("category", Ref("category", 3)), ("counts", Ref("counts", 3))]), toMap([])),
      ],
    ),
    (
      "entries",
      [
        Record(
          toMap([
            ("elems", Set([Ref("entry", 0), Ref("entry", 1), Ref("entry", 2), Ref("entry", 3)])),
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
    ("canvas", [Record(toMap([("entries", Ref("entries", 0))]), toMap([]))]),
  ])
}

let semanticEncoding: Semantic3.semanticEncoding = {
  open Encoding
  toMap([
    (
      "category",
      (
        Primitive(
          (text, {KiwiGlyph.left: left, bottom}) =>
            <g /* style={ReactDOM.Style.make(~transform=j`translate($left $bottom)`, ())} */
              transform={j`translate($left $bottom)`}>
              <text
                style={ReactDOM.Style.make(
                  ~font="light 16px sans-serif",
                //   ~transform="rotate(-90deg)",
                  (),
                )}>
                {text->React.string}
              </text>
            </g>,
        ),
        None,
        true,
      ),
    ),
    (
      "yes",
      (
        Primitive(
          (data, {KiwiGlyph.left: left, top}) =>
            <rect
              x={left->Js.Float.toString}
              y={top->Js.Float.toString}
              width={"20"}
              height={(Js.Float.fromString(data))->Js.Float.toString}
              style={ReactDOM.Style.make(~fill="#1f77b4", ())}
            />,
        ),
        None,
        true,
      ),
    ),
    (
      "no",
      (
        Primitive(
          (data, {KiwiGlyph.left: left, top}) =>
            <rect
              x={left->Js.Float.toString}
              y={top->Js.Float.toString}
              width={"20"}
              height={(Js.Float.fromString(data))->Js.Float.toString}
              style={ReactDOM.Style.make(~fill="#ff7f0e", ())}
            />,
        ),
        None,
        true,
      ),
    ),
    (
      "maybe",
      (
        Primitive(
          (data, {KiwiGlyph.left: left, top}) =>
            <rect
              x={left->Js.Float.toString}
              y={top->Js.Float.toString}
              width={"20"}
              height={(Js.Float.fromString(data))->Js.Float.toString}
              style={ReactDOM.Style.make(~fill="#2ca02c", ())}
            />,
        ),
        None,
        true,
      ),
    ),
    (
      "counts",
      (
        Record(
          None,
          toMap([]),
          [
            (["maybe"], ["no"], GestaltRelation.vAlignedGap(Num(0.), CenterX)),
            (["no"], ["yes"], GestaltRelation.vAlignedGap(Num(0.), CenterX)),
          ],
          toMap([]),
        ),
        None,
        false,
      ),
    ),
    (
      "entry",
      (
        Record(
          None,
          toMap([]),
          [(["counts"], ["category"], GestaltRelation.vAlignedGap(Num(10.), CenterX))],
          toMap([]),
        ),
        None,
        false,
      ),
    ),
    (
      "entries",
      (
        Record(
          None,
          toMap([]),
          [],
          toMap([
            (
              "sibling",
              (
                "curr",
                "next",
                GestaltRelation.combine(
                  GestaltRelation.hGap(Num(10.)),
                  GestaltRelation.bottomAlign,
                ),
              ),
            ),
          ]),
        ),
        None,
        false,
      ),
    ),
    ("canvas", (Record(None, toMap([]), [], toMap([])), None, false)),
  ])
}
