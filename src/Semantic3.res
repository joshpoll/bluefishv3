// Redesign of Glyph type.

type data = string
type field = string
type fieldType = string
type id = int

module GlyphType = {
  type relationType = Belt.Map.String.t<(string, string)> // TODO: should be some sort of accessor instead of string

  type rec t =
    | Primitive(string) // e.g. data
    | Set(t) // e.g. children set
    | Record(Belt.Map.String.t<t>, Belt.Map.String.t<relationType>) // e.g. node
}

module Glyph = {
  type rec t =
    | Ref(fieldType, id) // reference to another glyph
    | Primitive(data)
    | Set(array<t>)
    | Record(Belt.Map.String.t<t>, Belt.Map.String.t<relation>) // TODO: must include relations
  and relation = array<Belt.Map.String.t<t>>
}

module Encoding = {
  type mark = (data, KiwiGlyph.bbox) => React.element
  type recordMark = option<KiwiGlyph.bbox => React.element>

  type relation = (field, field, GestaltRelation.gestaltRelation)

  // TODO: this is weird because it's unclear who "owns" the rendering of glyphs
  type rec t =
    | Invisible
    | Primitive(mark)
    | Set(t)
    // anonymous (auto-derived) relations and explicit relations
    // todo: remove second arg? it's supposed to be for specifying layout of children defined in the
    // same place. But for this IR we're basically banning that. That's for the IR above this one.
    | Record(recordMark, Belt.Map.String.t<t>, array<relation>, Belt.Map.String.t<relation>)
}

// type relation =
//   | Primitive(array<data>)
//   // TODO: could specialize to just binary relations
//   // TODO: could generalize int in the case that the field could be anything (like with contains)
//   // TOOD: header should be (name, field) instead of just field
//   | Relation(array<(field, fieldType)>, array<array<id>>)

type semanticSchema = Belt.Map.String.t<GlyphType.t>

type semanticSystem = Belt.Map.String.t<array<Glyph.t>>

// bool is whether or not the glyph size is fixed.
// TODO: may want to push into Encoding.t
type semanticEncoding = Belt.Map.String.t<(Encoding.t, bool)>

let text = (style): Encoding.mark =>
  (text, {KiwiGlyph.left: left, bottom}) => {
    <text x={left->Js.Float.toString} y={bottom->Js.Float.toString} style>
      {text->React.string}
    </text>
  }

exception SemanticEncodingMismatch

let createGlyph = ((name: string, (glyphs: array<Glyph.t>, encoding: (Encoding.t, bool)))): array<
  Gestalt2.glyph,
> =>
  glyphs
  ->Belt.Array.mapWithIndex((i, glyph) => {
    switch (glyph, encoding) {
    // TODO: really just needs to return option
    | (Ref(_), _) => []
    | (Primitive(data), (Primitive(mark), fixedSize)) => [
        {
          Gestalt2.id: j`${name}_${Belt.Int.toString(i)}`,
          children: [],
          encoding: mark(data),
          fixedSize: fixedSize,
        },
      ]
    | (Set(_), _) => []
    | (Record(_), (Record(maybeMark, _, _, _), fixedSize)) => [
        {
          Gestalt2.id: j`${name}_${Belt.Int.toString(i)}`,
          children: [],
          encoding: switch maybeMark {
          | Some(mark) => mark
          | None => _ => <> </>
          },
          fixedSize: fixedSize,
        },
      ]
    | _ => raise(SemanticEncodingMismatch)
    }
  })
  ->Belt.Array.concatMany

// TODO: this should probably be a more elegant recursive function
let createContains = ((name: string, glyphs: array<Glyph.t>)): array<Gestalt2.relation> =>
  glyphs
  ->Belt.Array.mapWithIndex((i, glyph) =>
    switch glyph {
    | Ref(_) => [] // TODO: should really just be an option
    | Primitive(_) => []
    | Set(_) => []
    | Record(fields, _) => [
        {
          Gestalt2.instances: fields
          ->Belt.Map.String.valuesToArray
          ->Belt.Array.map(g =>
            switch g {
            | Ref(fieldType, idx) => [
                (j`${name}_${Belt.Int.toString(i)}`, j`${fieldType}_${Belt.Int.toString(idx)}`),
              ]
            | Set(elems) =>
              elems->Belt.Array.map((Ref(fieldType, idx)) => (
                j`${name}_${Belt.Int.toString(i)}`,
                j`${fieldType}_${Belt.Int.toString(idx)}`,
              ))
            }
          )
          ->Belt.Array.concatMany,
          gestalt: GestaltRelation.contains,
        },
      ]
    }
  )
  ->Belt.Array.concatMany

let resolveGlyph = (ss: semanticSystem, g: Glyph.t) =>
  switch g {
  | Ref(fieldType, i) => (ss->Belt.Map.String.getExn(fieldType))[i]
  | _ => g
  }

// TODO: track nested refs to the closest ref? might be needed for sets
// TODO: this is kind of an ugly hack since really need some nested namespaces or something
let rec resolveIndex = (g: Glyph.t, fields) =>
  switch g {
  | Ref(field, i) =>
    switch fields->Belt.Map.String.get(field) {
    | None => i
    | Some(glyph) => resolveIndex(glyph, fields)
    }
  | _ => raise(Not_found)
  }

/* TODO: ugly hack! */
let rec resolveGlyphName = ((field, i), fields: Belt.Map.String.t<Glyph.t>) =>
  switch fields->Belt.Map.String.get(field) {
  | None => j`${field}_${i->Belt.Int.toString}`
  | Some(Ref(field, i)) => resolveGlyphName((field, i), fields)
  | Some(Set(glyphs)) =>
    switch glyphs[i] {
    | Ref(field, i) => resolveGlyphName((field, i), fields)
    | _ => raise(Not_found)
    }
  | _ => raise(Not_found)
  }
and resolveGlyphNameRef = (Glyph.Ref(field, i), fields) => resolveGlyphName((field, i), fields)

let createRelations = ((
  _name: string,
  (glyphs: array<Glyph.t>, encoding: (Encoding.t, bool)),
)): array<Gestalt2.relation> =>
  glyphs
  ->Belt.Array.map(glyph =>
    switch (glyph, encoding) {
    | (Ref(_), _) => []
    | (Primitive(_), _) => []
    | (Set(_), _) => []
    | (Record(fields, relations), (Record(_, _, derivedRelationEncodings, relationEncodings), _)) =>
      Belt.Array.concat(
        derivedRelationEncodings->Belt.Array.map(((left, right, gestalt)) => {
          Gestalt2.instances: [
            (
              j`${left}_${fields
                ->Belt.Map.String.getExn(left)
                ->resolveIndex(Belt.Map.String.empty)
                ->Belt.Int.toString}`,
              j`${right}_${fields
                ->Belt.Map.String.getExn(right)
                ->resolveIndex(Belt.Map.String.empty)
                ->Belt.Int.toString}`,
            ),
          ],
          gestalt: gestalt,
        }),
        {
          let relationsAndEncodings = Belt.Map.String.merge(relations, relationEncodings, (
            _,
            ors,
            ores,
          ) =>
            switch (ors, ores) {
            | (None, _) | (_, None) => None // TODO: raise exception?
            | (Some(rs), Some(res)) => Some((rs, res))
            }
          )
          relationsAndEncodings
          ->Belt.Map.String.valuesToArray
          ->Belt.Array.map(((instances, (left, right, gestalt))) => {
            Gestalt2.instances: instances->Belt.Array.map(relFields => (
              relFields->Belt.Map.String.getExn(left)->resolveGlyphNameRef(fields),
              relFields->Belt.Map.String.getExn(right)->resolveGlyphNameRef(fields),
            )),
            gestalt: gestalt,
          })
        },
      )
    | _ => raise(SemanticEncodingMismatch)
    }
  )
  ->Belt.Array.concatMany

// TODO: this currently relies on a canvas_0 -> canvas rename hack!!
let toGestalt = (ss: semanticSystem, se: semanticEncoding): Gestalt2.system => {
  open! Belt

  // pair up data with its encoding
  let sse = Map.String.merge(ss, se, (_, oss, ose) =>
    switch (oss, ose) {
    | (None, _) | (_, None) => None // TODO: raise exception?
    | (Some(ss), Some(se)) => Some((ss, se))
    }
  )

  let glyphs = sse->Map.String.toArray->Array.map(createGlyph)->Array.concatMany

  let relations = Array.concat(
    ss->Map.String.toArray->Array.map(createContains)->Array.concatMany,
    sse->Map.String.toArray->Array.map(createRelations)->Array.concatMany,
  )

  Js.log2("glyphs", glyphs)
  Js.log2("relations", relations)

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
