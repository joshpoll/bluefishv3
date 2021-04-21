// Fig. 20 in the Penrose paper

/*

point : string

space : {
  name : text
  points : list(point)
}

map : {
  name : text
  from : space
  to : space

  rel fn : {from : from.points.elems, to : to.points.elems}
}

// TOP-LEVEL

rel fn : { name : text, from_space : text, to_space : text, from : point, to: point }

glyph space : { name : text, points : list(point) }

rel map : { name : text, from : space, to : space, from_point : point, to_point : point }

rel map_type : { name : text, from : space, to : space }

// nested relation
rel map : { map_type : int, from : point, to : point }

maps : list(map)

canvas : list(maps)

TODO: might be nice to have a graph of spaces?

rel children : { tree_ref : int, curr : tree, next : tree }

rel tree : { name : text, value : int, children : list(ref(tree)) }


glyph course : { name : text, num : text, instructors : text }
rel courses : { curr: course, next : course }


glyph U : { points : point* }
glyph V : { points : point* }


set('a) : glyph {
  elems : 'a*
}

list('a) : glyph {
  incl set('a)
  sibling : rel {curr : 'a, next : 'a}
}


----
glyph is like rel except singleton and has `contains` relations automatically
----

point : string

sibling : set { curr : point, next : point }

points : {
  elems : set points
  sibling : sibling
}

space : {
  name : text,
  points : list(point)
}

mapType : {
  name : text,
  from : space,
  to : space
}

fn : set { from : point, to : point }

map : {
  name : text
  fn : fn
}

penrose_set_map : glyph {
  mapTypes : mapTypes
  maps : maps
}

 */

// https://upload.wikimedia.org/wikipedia/commons/e/e8/Simple-bipartite-graph.svg

open Semantic3

let toMap = Belt.Map.String.fromArray

let semanticSystem = {
  open Glyph
  toMap([
    (
      "point",
      [
        Primitive("A"),
        Primitive("A"),
        Primitive("B"),
        Primitive("B"),
        Primitive("B"),
        Primitive("C"),
        Primitive("C"),
        Primitive("C"),
      ],
    ),
    (
      "space",
      [
        Record(
          toMap([("elems", Set([Ref("point", 0), Ref("point", 1)]))]),
          toMap([("sibling", [toMap([("curr", Ref("elems", 0)), ("next", Ref("elems", 1))])])]),
        ),
        Record(
          toMap([("elems", Set([Ref("point", 2), Ref("point", 3), Ref("point", 4)]))]),
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
          toMap([("elems", Set([Ref("point", 5), Ref("point", 6), Ref("point", 7)]))]),
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
      "spaces",
      [
        Record(
          toMap([
            ("elems", Set([Ref("space", 0), Ref("space", 1), Ref("space", 2)])),
            // ("label", Set([Ref("label", 0), Ref("label", 1), Ref("label", 2)])),
          ]),
          toMap([
            (
              "sibling",
              [
                toMap([("curr", Ref("elems", 0)), ("next", Ref("elems", 1))]),
                toMap([("curr", Ref("elems", 1)), ("next", Ref("elems", 2))]),
              ],
            ),
            // (
            //   /* TODO: this is superfluous since we need to include elems and label already! If we
            //    had access to global label, thin this would make sense. */
            //   "label-rel",
            //   [
            //     toMap([("space", Ref("elems", 0)), ("label", Ref("label", 0))]),
            //     toMap([("space", Ref("elems", 1)), ("label", Ref("label", 1))]),
            //     toMap([("space", Ref("elems", 2)), ("label", Ref("label", 2))]),
            //   ],
            // ),
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
                Ref("point", 0),
                Ref("point", 1),
                Ref("point", 2),
                Ref("point", 3),
                Ref("point", 4),
                Ref("point", 5),
                Ref("point", 6),
                Ref("point", 7),
              ]),
            ),
            ("spaces", Ref("spaces", 0)),
          ]),
          toMap([
            (
              "E",
              [
                // TODO: want U.elems and V.elems
                toMap([("from", Ref("elems", 0)), ("to", Ref("elems", 3))]),
                toMap([("from", Ref("elems", 1)), ("to", Ref("elems", 4))]),
                toMap([("from", Ref("elems", 2)), ("to", Ref("elems", 6))]),
                toMap([("from", Ref("elems", 3)), ("to", Ref("elems", 5))]),
                toMap([("from", Ref("elems", 4)), ("to", Ref("elems", 7))]),
              ],
            ),
          ]),
        ),
      ],
    ),
    ("label", [Primitive("A"), Primitive("B"), Primitive("C")]),
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
      "point",
      (
        Primitive(
          (color, {KiwiGlyph.centerX: centerX, centerY}) =>
            <circle
              r="7"
              cx={centerX->Js.Float.toString}
              cy={centerY->Js.Float.toString}
              style={ReactDOM.Style.make(
                ~fill="black",
                /* ~stroke="black", ~strokeWidth="3px", */ (),
              )}
            />,
        ),
        None,
        true,
      ),
    ),
    (
      "space",
      (
        Record(
          Some(
            Mark.ellipse(
              ReactDOM.Style.make(
                ~fill="blue",
                ~fillOpacity="0.3",
                ~stroke="black",
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
        Some({
          Gestalt2.left: (Eq, Num(30.)),
          right: (Eq, Num(30.)),
          top: (Eq, Num(20.)),
          bottom: (Eq, Num(20.)),
        }),
        false,
      ),
    ),
    (
      "spaces",
      (
        Record(
          None,
          toMap([]),
          [],
          toMap([
            ("sibling", ("curr", "next", GestaltRelation.hAlignedGap(Num(100.), CenterY))),
            // ("label-rel", ("label", "space", GestaltRelation.vAlignedGap(Num(10.), CenterX))),
          ]),
        ),
        None,
        false,
      ),
    ),
    (
      "bipartite_graph",
      (
        Record(None, toMap([]), [], toMap([("E", ("from", "to", GestaltRelation.link))])),
        None,
        false,
      ),
    ),
    ("canvas", (Record(None, toMap([]), [], toMap([])), None, false)),
  ])
}
