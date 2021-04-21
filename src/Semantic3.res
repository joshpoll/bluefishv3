// Redesign of Glyph type.

type data = string
type field = string
type path = array<string>
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

  let rec toJson = (glyph: t) => {
    open Js.Json
    switch glyph {
    | Ref(ft, id) =>
      object_(Js.Dict.fromArray([("type", string(ft)), ("ref", number(float_of_int(id)))]))
    | Primitive(s) => string(s)
    | Set(ts) => array(Belt.Array.map(ts, toJson))
    | Record(fields, relations) =>
      object_(
        Js.Dict.fromArray([
          (
            "fields",
            object_(
              fields->Belt.Map.String.map(toJson)->Belt.Map.String.toArray->Js.Dict.fromArray,
            ),
          ),
          (
            "relations",
            relations
            ->Belt.Map.String.map(relationToJson)
            ->Belt.Map.String.toArray
            ->Js.Dict.fromArray
            ->object_,
          ),
        ]),
      )
    }
  }
  and relationToJson = (relation: relation) =>
    relation
    ->Belt.Array.map(m =>
      m->Belt.Map.String.map(toJson)->Belt.Map.String.toArray->Js.Dict.fromArray
    )
    ->Js.Json.objectArray
}

module AnnotatedGlyph = {
  // Includes glyph names

  type rec t =
    | Ref(fieldType, id) // reference to another glyph
    | Primitive(string, data)
    | Set(array<t>)
    | Record(string, Belt.Map.String.t<t>, Belt.Map.String.t<relation>) // TODO: must include relations
  and relation = array<Belt.Map.String.t<t>>
}

module Encoding = {
  type mark = (data, KiwiGlyph.bbox) => React.element
  type recordMark = option<KiwiGlyph.bbox => React.element>

  type derivedRelation = (path, path, GestaltRelation.gestaltRelation)
  type relation = (field, field, GestaltRelation.gestaltRelation)

  // TODO: this is weird because it's unclear who "owns" the rendering of glyphs
  type rec t =
    | Invisible
    | Primitive(mark)
    | Set(t)
    // anonymous (auto-derived) relations and explicit relations
    // todo: remove second arg? it's supposed to be for specifying layout of children defined in the
    // same place. But for this IR we're basically banning that. That's for the IR above this one.
    | Record(recordMark, Belt.Map.String.t<t>, array<derivedRelation>, Belt.Map.String.t<relation>)
}

// type relation =
//   | Primitive(array<data>)
//   // TODO: could specialize to just binary relations
//   // TODO: could generalize int in the case that the field could be anything (like with contains)
//   // TOOD: header should be (name, field) instead of just field
//   | Relation(array<(field, fieldType)>, array<array<id>>)

type semanticSchema = Belt.Map.String.t<GlyphType.t>

type semanticSystem = Belt.Map.String.t<array<Glyph.t>>

let semanticSystemToJson = (ss: semanticSystem) =>
  Js.Json.object_(
    ss
    ->Belt.Map.String.map(v => Js.Json.array(v->Belt.Array.map(Glyph.toJson)))
    ->Belt.Map.String.toArray
    ->Js.Dict.fromArray,
  )

type annotatedSemanticSystem = Belt.Map.String.t<array<AnnotatedGlyph.t>>

// let annotateGlyph = (ss: semanticSystem, g: Glyph.t): AnnotatedGlyph.t =>
//   switch g {
//     | Ref(fieldType, id) => Ref(fieldType, id)
//     | Primitive(data) => raise(Not_found)
//     | Set(gs) =>
//     | Record(string, Belt.Map.String.t<t>, Belt.Map.String.t<relation>) // TODO: must include relations
//   }

exception BadAnnotate

// TODO: this code is super specialized to a particular shallow representation!
let annotateSystem = (ss: semanticSystem): annotatedSemanticSystem =>
  ss->Belt.Map.String.mapWithKey((name, gs) =>
    gs->Belt.Array.mapWithIndex((idx, g) =>
      switch g {
      | Ref(fieldType, id) => AnnotatedGlyph.Ref(fieldType, id)
      | Primitive(data) => Primitive(j`${name}_${Belt.Int.toString(idx)}`, data)
      | Set(gs) =>
        Set(
          gs->Belt.Array.map(g =>
            switch g {
            | Ref(fieldType, id) => AnnotatedGlyph.Ref(fieldType, id)
            | _ => raise(BadAnnotate)
            }
          ),
        )
      | Record(fields, relations) =>
        Record(
          j`${name}_${Belt.Int.toString(idx)}`,
          fields->Belt.Map.String.map(g =>
            switch g {
            | Ref(fieldType, id) => AnnotatedGlyph.Ref(fieldType, id)
            | Set(gs) =>
              Set(
                gs->Belt.Array.map(g =>
                  switch g {
                  | Ref(fieldType, id) => AnnotatedGlyph.Ref(fieldType, id)
                  | _ => raise(BadAnnotate)
                  }
                ),
              )
            | _ => raise(BadAnnotate)
            }
          ),
          relations->Belt.Map.String.map(r =>
            r->Belt.Array.map(row =>
              row->Belt.Map.String.map(g =>
                switch g {
                | Ref(fieldType, id) => AnnotatedGlyph.Ref(fieldType, id)
                | _ => raise(BadAnnotate)
                }
              )
            )
          ),
        )
      }
    )
  )

// bool is whether or not the glyph size is fixed.
// TODO: may want to push into Encoding.t
type semanticEncoding = Belt.Map.String.t<(Encoding.t, option<Gestalt2.padding>, bool)>

exception PathError

let rec resolveRef = (ss: annotatedSemanticSystem, name, idx): AnnotatedGlyph.t =>
  switch (ss->Belt.Map.String.getExn(name))[idx] {
  | Ref(name, idx) => resolveRef(ss, name, idx)
  | g => g
  }

let resolveGlyphNameRevised = (
  ss: annotatedSemanticSystem,
  g: AnnotatedGlyph.t,
  path: array<string>,
): array<string> => {
  let rec aux = (g: AnnotatedGlyph.t, path: list<string>) =>
    switch (g, path) {
    | (Ref(name, idx), path) => aux(resolveRef(ss, name, idx), path)
    | (Primitive(name, _), list{}) => [name]
    | (Primitive(_), list{_, ..._}) => raise(PathError)
    | (Record(name, _, _), list{}) => [name]
    | (Record(_, fields, _), list{field, ...path}) =>
      aux(fields->Belt.Map.String.getExn(field), path)
    | (Set(glyphs), path) => glyphs->Belt.Array.map(aux(_, path))->Belt.Array.concatMany
    }
  aux(g, path->Belt.List.fromArray)
}

exception SemanticEncodingMismatch

let createGlyph = ((
  glyphs: array<AnnotatedGlyph.t>,
  encoding: (Encoding.t, option<Gestalt2.padding>, bool),
)): array<Gestalt2.glyph> =>
  glyphs
  ->Belt.Array.map(glyph => {
    switch (glyph, encoding) {
    // TODO: really just needs to return option
    | (Ref(_), _) => []
    | (Primitive(name, data), (Primitive(mark), padding, fixedSize)) => [
        {
          Gestalt2.id: name,
          padding: padding,
          children: [],
          encoding: mark(data),
          fixedSize: fixedSize,
        },
      ]
    | (Set(_), _) => []
    | (Record(name, _, _), (Record(maybeMark, _, _, _), padding, fixedSize)) => [
        {
          Gestalt2.id: name,
          padding: padding,
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
let createContains = (ss: annotatedSemanticSystem, glyphs: array<AnnotatedGlyph.t>): array<
  Gestalt2.relation,
> =>
  glyphs
  ->Belt.Array.map(glyph =>
    switch glyph {
    | Ref(_) => [] // TODO: should really just be an option
    | Primitive(_) => []
    | Set(_) => []
    | Record(name, fields, _) => [
        {
          Gestalt2.instances: fields
          ->Belt.Map.String.valuesToArray
          ->Belt.Array.map(g =>
            resolveGlyphNameRevised(ss, g, [])->Belt.Array.map(n => (name ++ "_padding", n))
          )
          ->Belt.Array.concatMany,
          gestalt: GestaltRelation.contains,
        },
        {
          instances: [(name, name ++ "_padding")],
          gestalt: GestaltRelation.weakContains,
        },
      ]
    }
  )
  ->Belt.Array.concatMany

// let resolveGlyph = (ss: semanticSystem, g: Glyph.t) =>
//   switch g {
//   | Ref(fieldType, i) => (ss->Belt.Map.String.getExn(fieldType))[i]
//   | _ => g
//   }

// TODO: track nested refs to the closest ref? might be needed for sets
// TODO: this is kind of an ugly hack since really need some nested namespaces or something
let rec resolveIndex = (g: AnnotatedGlyph.t, fields) =>
  switch g {
  | Ref(field, i) =>
    switch fields->Belt.Map.String.get(field) {
    | None => i
    | Some(glyph) => resolveIndex(glyph, fields)
    }
  | Set(_) =>
    Js.log("Set")
    Js.log(g)
    raise(Not_found)
  | Record(_) =>
    Js.log("Record")
    raise(Not_found)
  | _ => raise(Not_found)
  }

/* TODO: ugly hack! */
let rec resolveGlyphName = ((field, i), fields: Belt.Map.String.t<AnnotatedGlyph.t>) =>
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
and resolveGlyphNameRef = (AnnotatedGlyph.Ref(field, i), fields) =>
  resolveGlyphName((field, i), fields)

let cartProd = (xs, ys) =>
  xs->Belt.Array.map(x => ys->Belt.Array.map(y => (x, y)))->Belt.Array.concatMany

let createRelations = (
  ss: annotatedSemanticSystem,
  (glyphs: array<AnnotatedGlyph.t>, encoding: (Encoding.t, option<Gestalt2.padding>, bool)),
): array<Gestalt2.relation> =>
  glyphs
  ->Belt.Array.map(glyph =>
    switch (glyph, encoding) {
    | (Ref(_), _) => []
    | (Primitive(_), _) => []
    | (Set(_), _) => []
    | (
        Record(_, fields, relations),
        (Record(_, _, derivedRelationEncodings, relationEncodings), _, _),
      ) =>
      Belt.Array.concat(
        derivedRelationEncodings->Belt.Array.map(((left, right, gestalt)) => {
          Gestalt2.instances: cartProd(
            resolveGlyphNameRevised(ss, glyph, left),
            resolveGlyphNameRevised(ss, glyph, right),
          ),
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
            Gestalt2.instances: instances
            ->Belt.Array.map(relFields =>
              cartProd(
                /* TODO: last spot!!! Semantics are not super great here so will have to revise */
                // This is doing a more local lookup than the other spots, which is why the behavior
                // is different.
                [relFields->Belt.Map.String.getExn(left)->resolveGlyphNameRef(fields)],
                [relFields->Belt.Map.String.getExn(right)->resolveGlyphNameRef(fields)],
              )
            )
            ->Belt.Array.concatMany,
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

  let ss = annotateSystem(ss)

  // pair up data with its encoding
  let sse = Map.String.merge(ss, se, (_, oss, ose) =>
    switch (oss, ose) {
    | (None, _) | (_, None) => None // TODO: raise exception?
    | (Some(ss), Some(se)) => Some((ss, se))
    }
  )

  let glyphs = sse->Map.String.valuesToArray->Array.map(createGlyph)->Array.concatMany

  let relations = Array.concat(
    ss->Map.String.valuesToArray->Array.map(createContains(ss))->Array.concatMany,
    sse->Map.String.valuesToArray->Array.map(createRelations(ss))->Array.concatMany,
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
          padding: None,
          children: [],
          encoding: _ => <> </>,
          fixedSize: false,
        },
      ],
    ),
  }
}
