/*
http://pythontutor.com/visualize.html#code=c+%3D+(1,+(2,+None))%0Ad+%3D+(1,+c)&mode=display&cumulative=false&py=2&curInstr=2
*/

open Semantic3

let toMap = Belt.Map.String.fromArray

let semanticSystem = {
  open Glyph
  toMap([
    ("stackHeader", [Primitive("Frames")]),
    ("heapHeader", [Primitive("Objects")]),
    (
      "tupleHeader",
      [
        Primitive("0"),
        Primitive("1"),
        Primitive("0"),
        Primitive("1"),
        Primitive("0"),
        Primitive("1"),
      ],
    ),
    (
      "tupleElt",
      [
        Primitive("1"),
        Primitive("??"),
        Primitive("2"),
        Primitive("None"),
        Primitive("1"),
        Primitive("??"),
      ],
    ),
    ("stackFrameHeader", [Primitive("Global frame")]),
    ("typeLabel", [Primitive("tuple"), Primitive("tuple"), Primitive("tuple")]),
    ("global val", [Primitive("??"), Primitive("??")]),
    (
      "stackFrameVar",
      [
        Record(toMap([("var", Ref("global name", 0))]), toMap([])),
        Record(toMap([("var", Ref("global name", 1))]), toMap([])),
      ],
    ),
    (
      "stackFrameValue",
      [
        Record(toMap([("value", Ref("global val", 0))]), toMap([])),
        Record(toMap([("value", Ref("global val", 1))]), toMap([])),
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
        )
      ],
    ),
    (
      "heapObject",
      [
        Record(toMap([("typeLabel", Ref("typeLabel", 0)), ("tuple", Ref("tuple", 0))]), toMap([])),
        Record(toMap([("typeLabel", Ref("typeLabel", 1)), ("tuple", Ref("tuple", 1))]), toMap([])),
        Record(toMap([("typeLabel", Ref("typeLabel", 2)), ("tuple", Ref("tuple", 2))]), toMap([])),
      ],
    ),
    ("global name", [Primitive("c"), Primitive("d")]),
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
              ]),
            ),
          ]),
          toMap([
            (
              "sibling",
              [
                toMap([("curr", Ref("elems", 0)), ("next", Ref("elems", 1))]),
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
            ("stackFrameHeader", Ref("stackFrameHeader", 0)),
            ("stackFrameVarTable", Ref("stackFrameVarTable", 0)),
          ]),
          toMap([]),
        ),
      ],
    ),
    (
      "tupleField",
      [
        Record(
          toMap([("tupleHeader", Ref("tupleHeader", 0)), ("tupleElt", Ref("tupleElt", 0))]),
          toMap([]),
        ),
        Record(
          toMap([("tupleHeader", Ref("tupleHeader", 1)), ("tupleElt", Ref("tupleElt", 1))]),
          toMap([]),
        ),
        Record(
          toMap([("tupleHeader", Ref("tupleHeader", 2)), ("tupleElt", Ref("tupleElt", 2))]),
          toMap([]),
        ),
        Record(
          toMap([("tupleHeader", Ref("tupleHeader", 3)), ("tupleElt", Ref("tupleElt", 3))]),
          toMap([]),
        ),
        Record(
          toMap([("tupleHeader", Ref("tupleHeader", 4)), ("tupleElt", Ref("tupleElt", 4))]),
          toMap([]),
        ),
        Record(
          toMap([("tupleHeader", Ref("tupleHeader", 5)), ("tupleElt", Ref("tupleElt", 5))]),
          toMap([]),
        ),
      ],
    ),
    (
      "globals_area",
      [
        Record(
          toMap([("stackHeader", Ref("stackHeader", 0)), ("stackFrame", Ref("stackFrame", 0))]),
          toMap([]),
        ),
      ],
    ),
    (
      "heapRow",
      [
        Record(
          toMap([("elems", Set([Ref("heapObject", 0), Ref("heapObject", 1)]))]),
          toMap([("sibling", [toMap([("curr", Ref("elems", 0)), ("next", Ref("elems", 1))])])]),
        ),
        Record(toMap([("elems", Set([Ref("heapObject", 2)]))]), toMap([("sibling", [])])),
      ],
    ),
    (
      "heapRows",
      [
        Record(
          toMap([("elems", Set([Ref("heapRow", 0), Ref("heapRow", 1)]))]),
          toMap([("sibling", [toMap([("curr", Ref("elems", 0)), ("next", Ref("elems", 1))])])]),
        ),
      ],
    ),
    (
      "tuple",
      [
        Record(
          toMap([("elems", Set([Ref("tupleField", 0), Ref("tupleField", 1)]))]),
          toMap([("sibling", [toMap([("curr", Ref("elems", 0)), ("next", Ref("elems", 1))])])]),
        ),
        Record(
          toMap([("elems", Set([Ref("tupleField", 2), Ref("tupleField", 3)]))]),
          toMap([("sibling", [toMap([("curr", Ref("elems", 0)), ("next", Ref("elems", 1))])])]),
        ),
        Record(
          toMap([("elems", Set([Ref("tupleField", 4), Ref("tupleField", 5)]))]),
          toMap([("sibling", [toMap([("curr", Ref("elems", 0)), ("next", Ref("elems", 1))])])]),
        ),
      ],
    ),
    (
      "heap",
      [
        Record(
          toMap([("heapHeader", Ref("heapHeader", 0)), ("heapRows", Ref("heapRows", 0))]),
          toMap([]),
        ),
      ],
    ),
    (
      "stackHeapTable",
      [
        Record(
          toMap([("globals_area", Ref("globals_area", 0)), ("heap", Ref("heap", 0))]),
          toMap([]),
        ),
      ],
    ),
    ("canvas", [Record(toMap([("stackHeapTable", Ref("stackHeapTable", 0))]), toMap([]))]),
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
            ReactDOM.Style.make(
              ~fontFamily="verdana, arial, helvetica, sans-serif",
              ~fontSize="10pt",
              ~color="#333333",
              (),
            ),
          ),
        ),
        None,
        true,
      ),
    ),
    (
      "typeLabel",
      (
        Primitive(
          Mark.text(
            ReactDOM.Style.make(
              ~fontFamily="verdana, arial, helvetica, sans-serif",
              ~fontSize="8pt",
              ~fill="#555",
              (),
            ),
          ),
        ),
        None,
        true,
      ),
    ),
    (
      "heapHeader",
      (
        Primitive(
          Mark.text(
            ReactDOM.Style.make(
              ~fontFamily="verdana, arial, helvetica, sans-serif",
              ~fontSize="10pt",
              ~color="#333333",
              (),
            ),
          ),
        ),
        None,
        true,
      ),
    ),
    (
      "tupleHeader",
      (
        Primitive(
          Mark.text(
            ReactDOM.Style.make(
              ~fontFamily="verdana, arial, helvetica, sans-serif",
              ~fontSize="8pt",
              ~fill="#777",
              (),
            ),
          ),
        ),
        None,
        true,
      ),
    ),
    (
      "stackFrameHeader",
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
      "tupleElt",
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
      "heapRow",
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
                  GestaltRelation.hGap(Num(30.)),
                  GestaltRelation.centerYAlign,
                ),
              ),
            ),
          ]),
        ),
        None,
        false,
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
      "tupleField",
      (
        Record(
          Some(
            Mark.rect(
              ReactDOM.Style.make(~fill="#ffffc6", ~fillOpacity="0.7", ~stroke="black", ()),
            )(""),
          ),
          toMap([]),
          [(["tupleHeader"], ["tupleElt"], GestaltRelation.vAlignedGap(Num(9.5), CenterX))],
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
      "tuple",
      (
        Record(
          None,
          toMap([]),
          [],
          toMap([("sibling", ("curr", "next", GestaltRelation.hAlignedGap(Num(0.), CenterY)))]),
        ),
        None,
        false,
      ),
    ),
    (
      "heapRows",
      (
        Record(
          None,
          toMap([]),
          [],
          toMap([("sibling", ("curr", "next", GestaltRelation.vGap(Num(10.))))]),
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
          [
            (
              ["stackFrameHeader"],
              ["stackFrameVarTable"],
              GestaltRelation.vAlignedGap(Num(9.5), Right),
            ),
          ],
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
    (
      "globals_area",
      (
        Record(
          None,
          toMap([]),
          [(["stackHeader"], ["stackFrame"], GestaltRelation.vAlignedGap(Num(10.), Right))],
          toMap([]),
        ),
        None,
        false,
      ),
    ),
    (
      "heap",
      (
        Record(
          None,
          toMap([]),
          [(["heapHeader"], ["heapRows"], GestaltRelation.vAlignedGap(Num(10.), Left))],
          toMap([]),
        ),
        None,
        false,
      ),
    ),
    (
      "heapObject",
      (
        Record(
          None,
          toMap([]),
          [(["typeLabel"], ["tuple"], GestaltRelation.vAlignedGap(Num(5.), Left))],
          toMap([]),
        ),
        None,
        false,
      ),
    ),
    (
      "stackHeapTable",
      (
        Record(
          None,
          toMap([]),
          [(["globals_area"], ["heap"], GestaltRelation.hAlignedGap(Num(50.), Top))],
          toMap([]),
        ),
        None,
        false,
      ),
    ),
    ("canvas", (Record(None, toMap([]), [], toMap([])), None, false)),
  ])
}
