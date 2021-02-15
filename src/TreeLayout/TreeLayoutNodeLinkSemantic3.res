// Tree Layout using Semantic3

open Semantic3

let toMap = Belt.Map.String.fromArray

/*

annotation : text

data : {
  annotation : annotation
}


data-children.elems.data

node : {
  data : data
  children : {
    elems : set(node)
    rel sibling : {curr: elems, next: elems}
  }
}

 */

let semanticSystem = {
  open Glyph
  toMap([
    (
      "annotation",
      [
        Primitive("Chart"),
        Primitive("Guide"),
        Primitive("Frame"),
        Primitive("Graph"),
        Primitive("Axis"),
        Primitive("Form"),
        Primitive("Contour"),
        Primitive("Point"),
        Primitive("Scale"),
        Primitive("Rule"),
        Primitive("Label"),
        Primitive("Line"),
        Primitive("Label"),
        Primitive("Curve"),
        Primitive("Symbol"),
        Primitive("Label"),
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
      ],
    ),
    (
      "children",
      [
        Record(
          toMap([("elems", Set([Ref("node", 1), Ref("node", 2), Ref("node", 3)]))]),
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
        Record(
          toMap([("elems", Set([Ref("node", 4), Ref("node", 5)]))]),
          toMap([("sibling", [toMap([("curr", Ref("elems", 0)), ("next", Ref("elems", 1))])])]),
        ),
        Record(toMap([("elems", Set([]))]), toMap([("sibling", [])])),
        Record(
          toMap([("elems", Set([Ref("node", 6), Ref("node", 7)]))]),
          toMap([("sibling", [toMap([("curr", Ref("elems", 0)), ("next", Ref("elems", 1))])])]),
        ),
        Record(
          toMap([("elems", Set([Ref("node", 8), Ref("node", 9), Ref("node", 10)]))]),
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
        Record(
          toMap([("elems", Set([Ref("node", 11), Ref("node", 12)]))]),
          toMap([("sibling", [toMap([("curr", Ref("elems", 0)), ("next", Ref("elems", 1))])])]),
        ),
        Record(toMap([("elems", Set([Ref("node", 13)]))]), toMap([("sibling", [])])),
        Record(
          toMap([("elems", Set([Ref("node", 14), Ref("node", 15)]))]),
          toMap([("sibling", [toMap([("curr", Ref("elems", 0)), ("next", Ref("elems", 1))])])]),
        ),
        Record(toMap([("elems", Set([]))]), toMap([("sibling", [])])),
        Record(toMap([("elems", Set([]))]), toMap([("sibling", [])])),
        Record(toMap([("elems", Set([]))]), toMap([("sibling", [])])),
        Record(toMap([("elems", Set([]))]), toMap([("sibling", [])])),
        Record(toMap([("elems", Set([]))]), toMap([("sibling", [])])),
        Record(toMap([("elems", Set([]))]), toMap([("sibling", [])])),
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
      ],
    ),
    ("canvas", [Record(toMap([("node", Ref("node", 0))]), toMap([]))]),
  ])
}

let semanticEncoding: Semantic3.semanticEncoding = {
  open Encoding
  toMap([
    (
      "annotation",
      (Primitive(Mark.text(ReactDOM.Style.make(~font="light 18px sans-serif", ()))), None, true),
    ),
    (
      "data",
      (
        Record(
          Some(
            ({KiwiGlyph.left: left, top}) =>
              <rect
                width="80"
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
        Some({
          Gestalt2.left: (TightGe, Num(5.)),
          right: (TightGe, Num(5.)),
          top: (TightGe, Num(0.)),
          bottom: (TightGe, Num(0.)),
        }),
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
        None,
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
        None,
        false,
      ),
    ),
    ("canvas", (Record(None, toMap([]), [], toMap([])), None, false)),
  ])
}

/*

children : {
  elems : set node
  rel sibling : {curr : elems, next : elems}
}

list('a) = {
  elems : set('a)
  sibling : {curr: elems, next: elems}
}

node : {
  data : data
  child : list(node)
  parent : list(node)

  child : {
    elems : set(node)
    sibling : {curr: elems, next: elems}
  }
  parent : {
    elems : set(node)
    sibling : {curr: elems, next: elems}
  }
}

node : {
  data : data
  child : set(node) {a1, a2}
  parent : set(node)

  parent_sibling : lone node
  child_sibling  : lone node

}

 */
