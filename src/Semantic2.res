// Changes from Semantic:
//    field names instead of positional numbers (i.e. tuple -> record)
//    relation gets an id (and instance of relation gets a sub-id?) instead of relation instances
//      getting id's
//    This is different b/c now a primitive doesn't operate like a unary relation. The distinction
//      between atoms and relations has precedent in nested relational algebra

type data = string
type field = string
type fieldType = string
type id = int

type relation =
  | Primitive(array<data>)
  // TODO: could specialize to just binary relations
  // TODO: could generalize int in the case that the field could be anything (like with contains)
  // TOOD: header should be (name, field) instead of just field
  | Relation(array<(field, fieldType)>, array<array<id>>)

type semanticSystem = Belt.Map.String.t<relation>

type glyph = (data, KiwiGlyph.bbox) => React.element
type group = option<KiwiGlyph.bbox => React.element>

type gestalt = (field, field, GestaltRelation.gestaltRelation)

type encoding =
  // bool represents whether or not fixed size
  | Glyph(glyph, bool)
  | Gestalt(group, bool, array<gestalt>)

type gestaltEncoding = Belt.Map.String.t<encoding>

let text = (style, text) => {
  ({KiwiGlyph.left: left, bottom}) => {
    <text x={left->Js.Float.toString} y={bottom->Js.Float.toString} style>
      {text->React.string}
    </text>
  }
}

exception SemanticEncodingMismatch

let createGlyph = ((name: string, (r: relation, e: encoding))): array<Gestalt.glyph> =>
  switch (r, e) {
  | (Primitive(datas), Glyph(encodingFn, fixedSize)) =>
    datas->Belt.Array.mapWithIndex((i, data) => {
      Gestalt.id: j`${name}_${Belt.Int.toString(i)}`,
      children: [],
      encoding: encodingFn(data),
      fixedSize: fixedSize,
    })
  | (Relation(_, datas), Gestalt(encoding, fixedSize, _)) =>
    datas->Belt.Array.mapWithIndex((i, _) => {
      Gestalt.id: j`${name}_${Belt.Int.toString(i)}`,
      children: [],
      encoding: switch encoding {
      | Some(e) => e
      | None => _ => <> </>
      },
      fixedSize: fixedSize,
    })
  | _ => raise(SemanticEncodingMismatch)
  }

let createContains = ((name: string, r: relation)): array<Gestalt.relation> =>
  switch r {
  | Primitive(_) => []
  | Relation(fields, datas) =>
    datas->Belt.Array.mapWithIndex((i, data) => {
      Gestalt.instances: fields->Belt.Array.mapWithIndex((j, (_field, fieldType)) => (
        j`${name}_${Belt.Int.toString(i)}`,
        j`${fieldType}_${Belt.Int.toString(data[j])}`,
      )),
      gestalt: GestaltRelation.contains,
    })
  }

let createRelations = ((_name: string, (r: relation, e: encoding))): array<Gestalt.relation> =>
  switch (r, e) {
  | (Primitive(_), _) => []
  | (Relation(fields, datas), Gestalt(_, _, gs)) =>
    gs->Belt.Array.map(((left, right, rel)) => {
      let leftIdx = fields->Belt.Array.getIndexBy(x => fst(x) == left)->Belt.Option.getExn
      let rightIdx = fields->Belt.Array.getIndexBy(x => fst(x) == right)->Belt.Option.getExn
      {
        Gestalt.instances: datas->Belt.Array.map(data => (
          j`${snd(fields[leftIdx])}_${Belt.Int.toString(data[leftIdx])}`,
          j`${snd(fields[rightIdx])}_${Belt.Int.toString(data[rightIdx])}`,
        )),
        gestalt: rel,
      }
    })
  | _ => raise(SemanticEncodingMismatch)
  }

// TODO: this currently relies on a canvas_0 -> canvas rename hack!!
let toGestalt = (s: semanticSystem, ge: gestaltEncoding): Gestalt.system => {
  open! Belt

  let sge = Map.String.merge(s, ge, (_, os, oge) =>
    switch (os, oge) {
    | (None, _) | (_, None) => None
    | (Some(s), Some(ge)) => Some((s, ge))
    }
  )

  let relations = Array.concat(
    s->Map.String.toArray->Array.map(createContains)->Array.concatMany,
    sge->Map.String.toArray->Array.map(createRelations)->Array.concatMany,
  )
  let glyphs = sge->Map.String.toArray->Array.map(createGlyph)->Array.concatMany

  // Js.log2("glyphs", glyphs)
  // Js.log2("relations", relations)

  {
    variables: [],
    constraints: [
      {
        lhs: AExpr(Var("canvas.left")),
        op: Eq,
        rhs: AExpr(Num(0.)),
        strength: Kiwi.Strength.required,
      },
      {
        lhs: AExpr(Var("canvas.top")),
        op: Eq,
        rhs: AExpr(Num(0.)),
        strength: Kiwi.Strength.required,
      },
      {
        lhs: AExpr(Var("canvas_0.left")),
        op: Eq,
        rhs: AExpr(Var("canvas.left")),
        strength: Kiwi.Strength.required,
      },
      {
        lhs: AExpr(Var("canvas_0.right")),
        op: Eq,
        rhs: AExpr(Var("canvas.right")),
        strength: Kiwi.Strength.required,
      },
      {
        lhs: AExpr(Var("canvas_0.top")),
        op: Eq,
        rhs: AExpr(Var("canvas.top")),
        strength: Kiwi.Strength.required,
      },
      {
        lhs: AExpr(Var("canvas_0.bottom")),
        op: Eq,
        rhs: AExpr(Var("canvas.bottom")),
        strength: Kiwi.Strength.required,
      },
    ],
    relations: relations,
    glyphs: Belt.Array.concat(
      glyphs,
      [
        {
          id: "canvas",
          children: [],
          encoding: _ => <> </>,
          fixedSize: false,
        },
      ],
    ),
  }
}
