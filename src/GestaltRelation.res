// Convenient functions for generating gestalt relations
open Kiwi.Strength

type glyph = string

type gestaltRelation = ((glyph, glyph)) => KiwiGlyph.constraints

let hGap = (gapExpr): gestaltRelation => {
  ((g1, g2)) => [
    {
      KiwiGlyph.lhs: AExpr(Add(Var(j`${g1}.right`), gapExpr)),
      op: Eq,
      rhs: AExpr(Var(j`${g2}.left`)),
      strength: strong,
    },
  ]
}

let vGap = (gapExpr): gestaltRelation => {
  ((g1, g2)) => [
    {
      KiwiGlyph.lhs: AExpr(Add(Var(j`${g1}.bottom`), gapExpr)),
      op: Eq,
      rhs: AExpr(Var(j`${g2}.top`)),
      strength: strong,
    },
  ]
}

let leftAlign: gestaltRelation = ((g1, g2)) => [
  {
    KiwiGlyph.lhs: AExpr(Var(j`${g1}.left`)),
    op: Eq,
    rhs: AExpr(Var(j`${g2}.left`)),
    strength: strong,
  },
]

let rightAlign: gestaltRelation = ((g1, g2)) => [
  {
    KiwiGlyph.lhs: AExpr(Var(j`${g1}.right`)),
    op: Eq,
    rhs: AExpr(Var(j`${g2}.right`)),
    strength: strong,
  },
]

let topAlign: gestaltRelation = ((g1, g2)) => [
  {
    KiwiGlyph.lhs: AExpr(Var(j`${g1}.top`)),
    op: Eq,
    rhs: AExpr(Var(j`${g2}.top`)),
    strength: strong,
  },
]

let bottomAlign: gestaltRelation = ((g1, g2)) => [
  {
    KiwiGlyph.lhs: AExpr(Var(j`${g1}.bottom`)),
    op: Eq,
    rhs: AExpr(Var(j`${g2}.bottom`)),
    strength: strong,
  },
]

let centerXAlign: gestaltRelation = ((g1, g2)) => [
  {
    KiwiGlyph.lhs: AExpr(Var(j`${g1}.centerX`)),
    op: Eq,
    rhs: AExpr(Var(j`${g2}.centerX`)),
    strength: strong,
  },
]

let centerYAlign: gestaltRelation = ((g1, g2)) => [
  {
    KiwiGlyph.lhs: AExpr(Var(j`${g1}.centerY`)),
    op: Eq,
    rhs: AExpr(Var(j`${g2}.centerY`)),
    strength: strong,
  },
]

let contains: gestaltRelation = ((g1, g2)) => [
  {
    KiwiGlyph.lhs: AExpr(Var(j`${g1}.left`)),
    op: Le,
    rhs: AExpr(Var(j`${g2}.left`)),
    strength: strong,
  },
  {
    KiwiGlyph.lhs: AExpr(Var(j`${g1}.left`)),
    op: Eq,
    rhs: AExpr(Var(j`${g2}.left`)),
    strength: weak,
  },
  {
    KiwiGlyph.lhs: AExpr(Var(j`${g1}.right`)),
    op: Ge,
    rhs: AExpr(Var(j`${g2}.right`)),
    strength: strong,
  },
  {
    KiwiGlyph.lhs: AExpr(Var(j`${g1}.right`)),
    op: Eq,
    rhs: AExpr(Var(j`${g2}.right`)),
    strength: weak,
  },
  {
    KiwiGlyph.lhs: AExpr(Var(j`${g1}.top`)),
    op: Le,
    rhs: AExpr(Var(j`${g2}.top`)),
    strength: strong,
  },
  {
    KiwiGlyph.lhs: AExpr(Var(j`${g1}.top`)),
    op: Eq,
    rhs: AExpr(Var(j`${g2}.top`)),
    strength: weak,
  },
  {
    KiwiGlyph.lhs: AExpr(Var(j`${g1}.bottom`)),
    op: Ge,
    rhs: AExpr(Var(j`${g2}.bottom`)),
    strength: strong,
  },
  {
    KiwiGlyph.lhs: AExpr(Var(j`${g1}.bottom`)),
    op: Eq,
    rhs: AExpr(Var(j`${g2}.bottom`)),
    strength: weak,
  },
]

type hAlignment =
  | Top
  | Bottom
  | CenterY

let hAlignedGap = (gapExpr, alignment): gestaltRelation => {
  ((g1, g2)) =>
    Belt.Array.concat(
      hGap(gapExpr, (g1, g2)),
      switch alignment {
      | Top => topAlign((g1, g2))
      | Bottom => bottomAlign((g1, g2))
      | CenterY => centerYAlign((g1, g2))
      },
    )
}

type vAlignment =
  | Left
  | Right
  | CenterX

let vAlignedGap = (gapExpr, alignment): gestaltRelation => {
  ((g1, g2)) =>
    Belt.Array.concat(
      vGap(gapExpr, (g1, g2)),
      switch alignment {
      | Left => leftAlign((g1, g2))
      | Right => rightAlign((g1, g2))
      | CenterX => centerXAlign((g1, g2))
      },
    )
}
