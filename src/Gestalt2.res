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

type operator =
  | Eq
  | Le
  | Ge
  | TightLe
  | TightGe

type padding = {
  left: (operator, KiwiGlyph.aexpr),
  right: (operator, KiwiGlyph.aexpr),
  top: (operator, KiwiGlyph.aexpr),
  bottom: (operator, KiwiGlyph.aexpr),
}

type glyph = {
  id: string,
  padding: option<padding>,
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

let paddingConstraint = (gid, direction, (op, expr)): KiwiGlyph.constraints =>
  switch op {
  | Eq => [
      {
        lhs: AExpr(Var(j`${gid}.${direction}`)),
        op: KiwiGlyph.Eq,
        rhs: AExpr(Add(Var(j`${gid}_padding.${direction}`), expr)),
        strength: Kiwi.Strength.required,
      },
    ]
  | Le => [
      {
        lhs: AExpr(Var(j`${gid}.${direction}`)),
        op: KiwiGlyph.Le,
        rhs: AExpr(Add(Var(j`${gid}_padding.${direction}`), expr)),
        strength: Kiwi.Strength.required,
      },
    ]
  | Ge => [
      {
        lhs: AExpr(Var(j`${gid}.${direction}`)),
        op: KiwiGlyph.Ge,
        rhs: AExpr(Add(Var(j`${gid}_padding.${direction}`), expr)),
        strength: Kiwi.Strength.required,
      },
    ]
  | TightLe => [
      {
        lhs: AExpr(Var(j`${gid}.${direction}`)),
        op: KiwiGlyph.Le,
        rhs: AExpr(Add(Var(j`${gid}_padding.${direction}`), expr)),
        strength: Kiwi.Strength.required,
      },
      {
        lhs: AExpr(Var(j`${gid}.${direction}`)),
        op: KiwiGlyph.Eq,
        rhs: AExpr(Add(Var(j`${gid}_padding.${direction}`), expr)),
        strength: Kiwi.Strength.weak,
      },
    ]
  | TightGe => [
      {
        lhs: AExpr(Var(j`${gid}.${direction}`)),
        op: KiwiGlyph.Ge,
        rhs: AExpr(Add(Var(j`${gid}_padding.${direction}`), expr)),
        strength: Kiwi.Strength.required,
      },
      {
        lhs: AExpr(Var(j`${gid}.${direction}`)),
        op: KiwiGlyph.Eq,
        rhs: AExpr(Add(Var(j`${gid}_padding.${direction}`), expr)),
        strength: Kiwi.Strength.weak,
      },
    ]
  }

let paddingConstraints = (g: glyph): KiwiGlyph.constraints => {
  let padding = switch g.padding {
  | None => {
      left: (Eq, Num(0.)),
      right: (Eq, Num(0.)),
      top: (Eq, Num(0.)),
      bottom: (Eq, Num(0.)),
    }
  | Some(padding) => padding
  }
  [
    paddingConstraint(g.id, "left", padding.left),
    paddingConstraint(g.id, "right", padding.right),
    paddingConstraint(g.id, "top", padding.top),
    paddingConstraint(g.id, "bottom", padding.bottom),
  ]->Belt.Array.concatMany
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
    let relationConstraints = relations->Array.map(r => r.constraints)->Array.concatMany
    let relationConnectors = relations->Array.map(r => r.connectors)->Array.concatMany
    let paddingConstraints = glyphs->Array.map(paddingConstraints)->Array.concatMany

    {
      KiwiGlyph.variables: variables->Array.map(variable),
      constraints: Array.concatMany([paddingConstraints, relationConstraints, constraints]),
      glyphs: glyphs->Array.map(glyph)->Array.concat(relationConnectors),
    }
  }
}
