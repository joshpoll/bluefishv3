/*
 */

open Semantic3

let toMap = Belt.Map.String.fromArray

let semanticSystem = {
  open Glyph
  toMap([
    ("stackHeader", [Primitive("Global frame")]),
    ("global val", [Primitive("5"), Primitive("10"), Primitive("15")]),
    (
      "stackFrameVar",
      [
        Record(toMap([("var", Ref("global name", 0))]), toMap([])),
        Record(toMap([("var", Ref("global name", 1))]), toMap([])),
        Record(toMap([("var", Ref("global name", 2))]), toMap([])),
      ],
    ),
    (
      "stackFrameValue",
      [
        Record(toMap([("value", Ref("global val", 0))]), toMap([])),
        Record(toMap([("value", Ref("global val", 1))]), toMap([])),
        Record(toMap([("value", Ref("global val", 2))]), toMap([])),
      ],
    ),
    (
      "stackFrameVariable",
      [
        Record(
          toMap([
            ("stackFrameVar", Ref("stackFrameVar", 0)),
            ("stackFrameValue", Ref("stackFrameValue", 0)),
          ]),
          toMap([]),
        ),
        Record(
          toMap([
            ("stackFrameVar", Ref("stackFrameVar", 1)),
            ("stackFrameValue", Ref("stackFrameValue", 1)),
          ]),
          toMap([]),
        ),
        Record(
          toMap([
            ("stackFrameVar", Ref("stackFrameVar", 2)),
            ("stackFrameValue", Ref("stackFrameValue", 2)),
          ]),
          toMap([]),
        ),
      ],
    ),
    ("global name", [Primitive("x"), Primitive("y"), Primitive("z")]),
    (
      "stackFrameVarTable",
      [
        Record(
          toMap([
            (
              "elems",
              Set([
                Ref("stackFrameVariable", 0),
                Ref("stackFrameVariable", 1),
                Ref("stackFrameVariable", 2),
              ]),
            ),
          ]),
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
    (
      "stackFrame",
      [
        Record(
          toMap([
            ("stackHeader", Ref("stackHeader", 0)),
            ("stackFrameVarTable", Ref("stackFrameVarTable", 0)),
          ]),
          toMap([]),
        ),
      ],
    ),
    ("canvas", [Record(toMap([("stackFrame", Ref("stackFrame", 0))]), toMap([]))]),
  ])
}

let semanticEncoding: Semantic3.semanticEncoding = {
  open Encoding
  toMap([
    (
      "stackHeader",
      (
        Primitive(
          Mark.text(
            ReactDOM.Style.make(~fontFamily="Andale mono, monospace", ~fontSize="10pt", ()),
          ),
        ),
        None,
        true,
      ),
    ),
    (
      "global val",
      (
        Primitive(
          Mark.text(
            ReactDOM.Style.make(
              ~fontFamily="verdana, arial, helvetica, sans-serif",
              ~fontSize="10pt",
              (),
            ),
          ),
        ),
        None,
        true,
      ),
    ),
    (
      "global name",
      (
        Primitive(
          Mark.text(
            ReactDOM.Style.make(
              ~fontFamily="verdana, arial, helvetica, sans-serif",
              ~fontSize="10pt",
              (),
            ),
          ),
        ),
        None,
        true,
      ),
    ),
    ("stackFrameVar", (Record(None, toMap([]), [], toMap([])), None, false)),
    (
      "stackFrameValue",
      (
        Record(
          //   Some(
          //     Mark.rect(
          //       ReactDOM.Style.make(
          //         ~borderBottom="1px solid #aaaaaa",
          //         ~borderLeft="1px solid #aaaaaa",
          //         ~fillOpacity="0.3",
          //         (),
          //       ),
          //     )(""),
          //   ),
          None,
          toMap([]),
          [],
          toMap([]),
        ),
        None,
        false,
      ),
    ),
    (
      "stackFrameVariable",
      (
        Record(
          None,
          toMap([]),
          [(["stackFrameVar"], ["stackFrameValue"], GestaltRelation.hAlignedGap(Num(9.5), Bottom))],
          toMap([]),
        ),
        None,
        false,
      ),
    ),
    (
      "stackFrameVarTable",
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
                GestaltRelation.combine(GestaltRelation.vGap(Num(10.)), GestaltRelation.leftAlign),
              ),
            ),
          ]),
        ),
        None,
        false,
      ),
    ),
    (
      "stackFrame",
      (
        Record(
             Some(
              Mark.rect(
                ReactDOM.Style.make(
                  ~fill="#e2ebf6",
                  ~fillOpacity="0.5",
                //   ~stroke="black",
                    //   hack
                //   ~strokeDasharray="0,190,30",
                  (),
                ),
              )(""),
            ),
          toMap([]),
          [(["stackHeader"], ["stackFrameVarTable"], GestaltRelation.vAlignedGap(Num(9.5), Right))],
          toMap([]),
        ),
        Some({
            Gestalt2.left: (Gestalt2.Eq, KiwiGlyph.Num(5.)),
            Gestalt2.right: (Gestalt2.Eq, KiwiGlyph.Num(5.)),
            Gestalt2.top: (Gestalt2.Eq, KiwiGlyph.Num(5.)),
            Gestalt2.bottom: (Gestalt2.Eq, KiwiGlyph.Num(10.)),
        }),
        false,
      ),
    ),
    ("canvas", (Record(None, toMap([]), [], toMap([])), None, false)),
  ])
}
