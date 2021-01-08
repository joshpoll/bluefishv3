// TODO: I've been more lazy here by not copying all the KiwiGlyph primitives over.
exception TODO

type variable = {
  id: string,
  varOpt: KiwiDeclarative.variableOption,
}

type gestalt = ((string, string)) => KiwiGlyph.constraints

type relation = {
  instances: array<(string, string)>,
  gestalt: gestalt,
}

type glyph = {
  id: string,
  children: array<string>,
  encoding: KiwiGlyph.bbox => React.element,
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

  let relation = ({instances, gestalt}) => instances->Belt.Array.map(gestalt)->Belt.Array.concatMany

  let glyph = ({id, children, encoding}) => {
    KiwiGlyph.id: id,
    children: children,
    encoding: encoding,
  }

  let system = ({variables, constraints, relations, glyphs}) => {
    open! Belt

    {
      KiwiGlyph.variables: variables->Array.map(variable),
      constraints: Array.concat(relations->Array.map(relation)->Array.concatMany, constraints),
      glyphs: glyphs->Array.map(glyph),
    }
  }
}
