// Convenient functions for generating gestalt relations
open Kiwi.Strength

let counter = ref(0)

let genFresh = () => {
  counter := counter.contents + 1
  string_of_int(counter.contents - 1)
}

type glyph = string

// type gestaltEncoding = {
//   constraints: KiwiGlyph.constraints,
//   connectors: array<KiwiGlyph.glyph>,
// }

type gestaltRelConstraint = ((glyph, glyph)) => KiwiGlyph.constraints
type gestaltRelConnector = ((glyph, glyph)) => array<KiwiGlyph.glyph>

type gestaltRelation = ((glyph, glyph)) => Gestalt2.gestaltEncoding

let fromRelConstraint = (r: gestaltRelConstraint): gestaltRelation =>
  ((g1, g2)) => {
    constraints: r((g1, g2)),
    connectors: [],
  }

let fromRelConnector = (r: gestaltRelConnector): gestaltRelation =>
  ((g1, g2)) => {
    constraints: [],
    connectors: r((g1, g2)),
  }

let combine = (r1: gestaltRelation, r2: gestaltRelation): gestaltRelation => {
  ((g1, g2)) => {
    let r1Encoding = r1((g1, g2))
    let r2Encoding = r2((g1, g2))
    {
      constraints: Belt.Array.concat(r1Encoding.constraints, r2Encoding.constraints),
      connectors: Belt.Array.concat(r1Encoding.connectors, r2Encoding.connectors),
    }
  }
}

let hGap = (gapExpr): gestaltRelation =>
  fromRelConstraint(((g1, g2)) => [
    {
      KiwiGlyph.lhs: AExpr(Add(Var(j`${g1}.right`), gapExpr)),
      op: Eq,
      rhs: AExpr(Var(j`${g2}.left`)),
      strength: strong,
    },
  ])

let vGap = (gapExpr): gestaltRelation =>
  fromRelConstraint(((g1, g2)) => [
    {
      KiwiGlyph.lhs: AExpr(Add(Var(j`${g1}.bottom`), gapExpr)),
      op: Eq,
      rhs: AExpr(Var(j`${g2}.top`)),
      strength: strong,
    },
  ])

let leftAlign: gestaltRelation = fromRelConstraint(((g1, g2)) => [
  {
    KiwiGlyph.lhs: AExpr(Var(j`${g1}.left`)),
    op: Eq,
    rhs: AExpr(Var(j`${g2}.left`)),
    strength: strong,
  },
])

let rightAlign: gestaltRelation = fromRelConstraint(((g1, g2)) => [
  {
    KiwiGlyph.lhs: AExpr(Var(j`${g1}.right`)),
    op: Eq,
    rhs: AExpr(Var(j`${g2}.right`)),
    strength: strong,
  },
])

let topAlign: gestaltRelation = fromRelConstraint(((g1, g2)) => [
  {
    KiwiGlyph.lhs: AExpr(Var(j`${g1}.top`)),
    op: Eq,
    rhs: AExpr(Var(j`${g2}.top`)),
    strength: strong,
  },
])

let bottomAlign: gestaltRelation = fromRelConstraint(((g1, g2)) => [
  {
    KiwiGlyph.lhs: AExpr(Var(j`${g1}.bottom`)),
    op: Eq,
    rhs: AExpr(Var(j`${g2}.bottom`)),
    strength: strong,
  },
])

let centerXAlign: gestaltRelation = fromRelConstraint(((g1, g2)) => [
  {
    KiwiGlyph.lhs: AExpr(Var(j`${g1}.centerX`)),
    op: Eq,
    rhs: AExpr(Var(j`${g2}.centerX`)),
    strength: strong,
  },
])

let centerYAlign: gestaltRelation = fromRelConstraint(((g1, g2)) => [
  {
    KiwiGlyph.lhs: AExpr(Var(j`${g1}.centerY`)),
    op: Eq,
    rhs: AExpr(Var(j`${g2}.centerY`)),
    strength: strong,
  },
])

let widthAlign: gestaltRelation = fromRelConstraint(((g1, g2)) => [
  {
    KiwiGlyph.lhs: AExpr(Var(j`${g1}.width`)),
    op: Eq,
    rhs: AExpr(Var(j`${g2}.width`)),
    strength: strong,
  },
])

let contains = (~tight=false): gestaltRelation =>
  fromRelConstraint(((g1, g2)) => [
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
      strength: if tight {
        medium
      } else {
        weak
      },
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
      strength: if tight {
        medium
      } else {
        weak
      },
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
      strength: if tight {
        medium
      } else {
        weak
      },
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
      strength: if tight {
        medium
      } else {
        weak
      },
    },
  ])

type hAlignment =
  | Top
  | Bottom
  | CenterY

let hAlignedGap = (gapExpr, alignment): gestaltRelation =>
  combine(
    hGap(gapExpr),
    switch alignment {
    | Top => topAlign
    | Bottom => bottomAlign
    | CenterY => centerYAlign
    },
  )

type vAlignment =
  | Left
  | Right
  | CenterX

let vAlignedGap = (gapExpr, alignment): gestaltRelation =>
  combine(
    vGap(gapExpr),
    switch alignment {
    | Left => leftAlign
    | Right => rightAlign
    | CenterX => centerXAlign
    },
  )

let link = ((g1, g2)) => {
  Js.log2(g1, g2)
  let linkName = j`link_${genFresh()}`
  {
    Gestalt2.constraints: [
      {
        KiwiGlyph.lhs: AExpr(Var(j`${g1}.centerX`)),
        op: Eq,
        rhs: AExpr(Var(j`${linkName}.left`)),
        strength: strong,
      },
      {
        KiwiGlyph.lhs: AExpr(Var(j`${g1}.centerY`)),
        op: Eq,
        rhs: AExpr(Var(j`${linkName}.top`)),
        strength: strong,
      },
      {
        KiwiGlyph.lhs: AExpr(Var(j`${g2}.centerX`)),
        op: Eq,
        rhs: AExpr(Var(j`${linkName}.right`)),
        strength: strong,
      },
      {
        KiwiGlyph.lhs: AExpr(Var(j`${g2}.centerY`)),
        op: Eq,
        rhs: AExpr(Var(j`${linkName}.bottom`)),
        strength: strong,
      },
    ],
    connectors: [
      {
        KiwiGlyph.id: linkName,
        children: [],
        encoding: ({KiwiGlyph.left: left, top, right, bottom}) =>
          <line
            x1={Js.Float.toString(left)}
            y1={Js.Float.toString(top)}
            x2={Js.Float.toString(right)}
            y2={Js.Float.toString(bottom)}
            style={ReactDOM.Style.make(~stroke="magenta", ~strokeWidth="3px", ())}
          />,
        fixedSize: false,
      },
    ],
  }
}
