open Semantic2

let semanticSystem = Belt.Map.String.fromArray([
  ("data", Primitive(["red", "green", "blue"])),
  ("children", Relation([("curr", "node"), ("right", "node")], [[1, 2]])),
  ("node", Relation([("data", "data"), ("children", "children")], [[0, 0]])),
  ("canvas", Relation([("node", "node")], [[0]])),
])

let encoding = (color, {KiwiGlyph.left: left, top, width: _width, height: _height}) =>
  <rect
    x={Js.Float.toString(left)}
    y={Js.Float.toString(top)}
    width={Js.Float.toString(10.)}
    height={Js.Float.toString(10.)}
    style={ReactDOM.Style.make(~fill=color, ~fillOpacity="0.3", ~stroke="black", ())}
  />

let gestaltEncoding = Belt.Map.String.fromArray([
  ("data", Glyph(encoding, true)),
  (
    "children",
    Gestalt(None, false, [("left", "right", GestaltRelation.hAlignedGap(Num(20.), Top))]),
  ),
  (
    "node",
    Gestalt(None, false, [("data", "children", GestaltRelation.vAlignedGap(Num(20.), CenterX))]),
  ),
  ("canvas", Gestalt(None, false, [])),
])
