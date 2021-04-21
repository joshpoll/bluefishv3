/*
  GOAL: Sort of like an ANF where everything is either primitive or a ref.
  Currently only broken by `Set`, but that could be changed in the future.
*/

/*
2013-01,53
2013-02,165
2013-03,269
2013-04,344
2013-05,376
2013-06,410
2013-07,421
2013-08,405
2013-09,376
2013-10,359
2013-11,392
2013-12,433
2014-01,455
2014-02,478
 */

open Semantic3

let toMap = Belt.Map.String.fromArray

let semanticSystem = {
  open Glyph
  toMap([
    (
      "date",
      [
        Primitive("2013-01"),
        Primitive("2013-02"),
        Primitive("2013-03"),
        Primitive("2013-04"),
        Primitive("2013-05"),
        Primitive("2013-06"),
        Primitive("2013-07"),
        Primitive("2013-08"),
        Primitive("2013-09"),
        Primitive("2013-10"),
        Primitive("2013-11"),
        Primitive("2013-12"),
        Primitive("2014-01"),
        Primitive("2014-02"),
      ],
    ),
    (
      "value",
      [
        Primitive("53"),
        Primitive("165"),
        Primitive("269"),
        Primitive("344"),
        Primitive("376"),
        Primitive("410"),
        Primitive("421"),
        Primitive("405"),
        Primitive("376"),
        Primitive("359"),
        Primitive("392"),
        Primitive("433"),
        Primitive("455"),
        Primitive("478"),
      ],
    ),
    (
      "entry",
      [
        Record(toMap([("date", Ref("date", 0)), ("value", Ref("value", 0))]), toMap([])),
        Record(toMap([("date", Ref("date", 1)), ("value", Ref("value", 1))]), toMap([])),
        Record(toMap([("date", Ref("date", 2)), ("value", Ref("value", 2))]), toMap([])),
        Record(toMap([("date", Ref("date", 3)), ("value", Ref("value", 3))]), toMap([])),
        Record(toMap([("date", Ref("date", 4)), ("value", Ref("value", 4))]), toMap([])),
        Record(toMap([("date", Ref("date", 5)), ("value", Ref("value", 5))]), toMap([])),
        Record(toMap([("date", Ref("date", 6)), ("value", Ref("value", 6))]), toMap([])),
        Record(toMap([("date", Ref("date", 7)), ("value", Ref("value", 7))]), toMap([])),
        Record(toMap([("date", Ref("date", 8)), ("value", Ref("value", 8))]), toMap([])),
        Record(toMap([("date", Ref("date", 9)), ("value", Ref("value", 9))]), toMap([])),
        Record(toMap([("date", Ref("date", 10)), ("value", Ref("value", 10))]), toMap([])),
        Record(toMap([("date", Ref("date", 11)), ("value", Ref("value", 11))]), toMap([])),
        Record(toMap([("date", Ref("date", 12)), ("value", Ref("value", 12))]), toMap([])),
        Record(toMap([("date", Ref("date", 13)), ("value", Ref("value", 13))]), toMap([])),
      ],
    ),
    (
      "entries",
      [
        Record(
          toMap([
            (
              "elems",
              Set([
                Ref("entry", 0),
                Ref("entry", 1),
                Ref("entry", 2),
                Ref("entry", 3),
                Ref("entry", 4),
                Ref("entry", 5),
                Ref("entry", 6),
                Ref("entry", 7),
                Ref("entry", 8),
                Ref("entry", 9),
                Ref("entry", 10),
                Ref("entry", 11),
                Ref("entry", 12),
                Ref("entry", 13),
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
                toMap([("curr", Ref("elems", 5)), ("next", Ref("elems", 6))]),
                toMap([("curr", Ref("elems", 6)), ("next", Ref("elems", 7))]),
                toMap([("curr", Ref("elems", 7)), ("next", Ref("elems", 8))]),
                toMap([("curr", Ref("elems", 8)), ("next", Ref("elems", 9))]),
                toMap([("curr", Ref("elems", 9)), ("next", Ref("elems", 10))]),
                toMap([("curr", Ref("elems", 10)), ("next", Ref("elems", 11))]),
                toMap([("curr", Ref("elems", 11)), ("next", Ref("elems", 12))]),
                toMap([("curr", Ref("elems", 12)), ("next", Ref("elems", 13))]),
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
      "date",
      (
        Primitive(
          (text, {KiwiGlyph.left: left, bottom}) =>
            <g /* style={ReactDOM.Style.make(~transform=j`translate($left $bottom)`, ())} */
                transform={j`translate($left $bottom)`}
            >
              <text
                style={ReactDOM.Style.make(~font="light 16px sans-serif", ~transform="rotate(-90deg)", ())}>
                {text->React.string}
              </text>
            </g>,
        ),
        None,
        true,
      ),
    ),
    (
      "value",
      (
        Primitive(
          (data, {KiwiGlyph.left: left, top}) =>
            <rect
              x={left->Js.Float.toString}
              y={top->Js.Float.toString}
              width={"20"}
              height={(Js.Float.fromString(data) /. 3.)->Js.Float.toString}
              style={ReactDOM.Style.make(~fill="steelblue", ())}
            />,
        ),
        None,
        true,
      ),
    ),
    (
      "entry",
      (
        Record(
          None,
          toMap([]),
          [(["value"], ["date"], GestaltRelation.vAlignedGap(Num(10.), CenterX))],
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
