// Like Gestalt, but adds support for links
// TODO: I've been more lazy here by not copying all the KiwiGlyph primitives over.
exception TODO

type variable = {
  id: string,
  varOpt: KiwiDeclarative.variableOption,
}

type gestaltEncoding = {
  constraints: KiwiGlyph.constraints,
  connectors: array<KiwiGlyph.glyph>,
}

type gestalt = ((string, string)) => gestaltEncoding

type relation = {
  instances: array<(string, string)>,
  gestalt: gestalt,
}

type glyph = {
  id: string,
  children: array<string>,
  encoding: KiwiGlyph.bbox => React.element,
  fixedSize: bool,
}

type variables = array<variable>
type relations = array<relation>
type glyphs = array<glyph>

type system = {
  variables: variables,
  constraints: KiwiGlyph.constraints,
  relations: relations,
  glyphs: glyphs,
}

module Lower = {
  let variable = ({id, varOpt}) => {KiwiGlyph.id: id, varOpt: varOpt}

  // CAN ONLY APPLY RELATIONS ONCE SINCE MAY HAVE SIDE-EFFECTS!!!
  let relation = ({instances, gestalt}) => instances->Belt.Array.map(gestalt)
  let relationConstraints = r =>
    r->relation->Belt.Array.map(r => r.constraints)->Belt.Array.concatMany
  let relationConnectors = r =>
    r->relation->Belt.Array.map(r => r.connectors)->Belt.Array.concatMany

  let glyph = ({id, children, encoding, fixedSize}) => {
    KiwiGlyph.id: id,
    children: children,
    encoding: encoding,
    fixedSize: fixedSize,
  }

  let system = ({variables, constraints, relations, glyphs}) => {
    open! Belt

    let relations = relations->Array.map(relation)->Array.concatMany
    let relationConstraints = relations->Belt.Array.map(r => r.constraints)->Belt.Array.concatMany
    let relationConnectors = relations->Belt.Array.map(r => r.connectors)->Belt.Array.concatMany

    {
      KiwiGlyph.variables: variables->Array.map(variable),
      constraints: Array.concat(relationConstraints, constraints),
      glyphs: glyphs->Array.map(glyph)->Array.concat(relationConnectors),
    }
  }
}
