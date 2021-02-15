// a library of basic Bluefish marks/glyphs

let text = (style): Semantic3.Encoding.mark =>
  (text, {KiwiGlyph.left: left, bottom}) =>
    <text x={left->Js.Float.toString} y={bottom->Js.Float.toString} style>
      {text->React.string}
    </text>

// TODO: data???
let rect = (style): Semantic3.Encoding.mark =>
  (_data, {KiwiGlyph.left: left, top, width, height}) =>
    <rect
      x={left->Js.Float.toString}
      y={top->Js.Float.toString}
      width={Js.Float.toString(width)}
      height={Js.Float.toString(height)}
      style
    />

let ellipse = (style): Semantic3.Encoding.mark =>
  (_data, {KiwiGlyph.centerX: centerX, centerY, width, height}) =>
    <ellipse
      cx={centerX->Js.Float.toString}
      cy={centerY->Js.Float.toString}
      rx={Js.Float.toString(width /. 2.)}
      ry={Js.Float.toString(height /. 2.)}
      style
    />
