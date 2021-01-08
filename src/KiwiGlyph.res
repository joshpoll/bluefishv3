exception TODO

type variable = {
  id: string,
  varOpt: KiwiDeclarative.variableOption,
}

type rec aexpr =
  | Num(float)
  | Var(string)
  | Add(aexpr, aexpr)
  | Sub(aexpr, aexpr)
  | Mul(aexpr, float)
  | Div(aexpr, float)

type cexpr =
  | Max(array<aexpr>)
  | Min(array<aexpr>)

type expr =
  | AExpr(aexpr)
  | CExpr(cexpr)

type operator =
  | Le
  | Ge
  | Eq

type constraint_ = {
  lhs: expr,
  op: operator,
  rhs: expr,
  strength: Kiwi.Strength.t,
}

type bbox = {
  left: float,
  right: float,
  top: float,
  bottom: float,
  width: float,
  height: float,
  centerX: float,
  centerY: float,
  scaleX: float,
  scaleY: float,
}

type glyph = {
  id: string,
  children: array<string>,
  // TODO: add bbox inputs
  encoding: bbox => React.element,
  fixedSize: bool,
}

type variables = array<variable>
type constraints = array<constraint_>
type glyphs = array<glyph>

type system = {
  variables: variables,
  constraints: constraints,
  glyphs: glyphs,
}

module Encode = {
  open! Json.Encode

  let varOpt = r =>
    switch r {
    | KiwiDeclarative.Suggest(value, strength) =>
      object_(
        [
          ("opt", string("suggest")),
          ("value", float(value)),
          ("strength", float(strength)),
        ] |> Array.to_list,
      )
    | Stay(strength) =>
      object_([("opt", string("stay")), ("strength", float(strength))] |> Array.to_list)
    | Derived => object_([("opt", string("derived"))] |> Array.to_list)
    }

  let variable = (r: variable) =>
    object_([("id", string(r.id)), ("varOpt", varOpt(r.varOpt))] |> Array.to_list)

  let rec aexpr = r =>
    switch r {
    | Num(x) => object_([("tag", string("num")), ("value", float(x))] |> Array.to_list)
    | Var(v) => object_([("tag", string("var")), ("value", string(v))] |> Array.to_list)
    | Add(ae1, ae2) =>
      object_([("tag", string("+")), ("ae1", aexpr(ae1)), ("ae2", aexpr(ae2))] |> Array.to_list)
    | Sub(ae1, ae2) =>
      object_([("tag", string("-")), ("ae1", aexpr(ae1)), ("ae2", aexpr(ae2))] |> Array.to_list)
    | Mul(ae1, f2) =>
      object_([("tag", string("*")), ("ae1", aexpr(ae1)), ("f2", float(f2))] |> Array.to_list)
    | Div(ae1, f2) =>
      object_([("tag", string("/")), ("ae1", aexpr(ae1)), ("f2", float(f2))] |> Array.to_list)
    }

  let cexpr = r =>
    switch r {
    | Max(aes) => object_([("tag", string("max")), ("aes", array(aexpr, aes))] |> Array.to_list)
    | Min(aes) => object_([("tag", string("min")), ("aes", array(aexpr, aes))] |> Array.to_list)
    }

  let expr = r =>
    switch r {
    | AExpr(ae) => object_([("tag", string("aexpr")), ("value", aexpr(ae))] |> Array.to_list)
    | CExpr(ce) => object_([("tag", string("cexpr")), ("value", cexpr(ce))] |> Array.to_list)
    }

  let operator = r =>
    switch r {
    | Le => string("<=")
    | Ge => string(">=")
    | Eq => string("==")
    }

  let constraint_ = r =>
    object_(
      [
        ("lhs", expr(r.lhs)),
        ("op", operator(r.op)),
        ("rhs", expr(r.rhs)),
        ("strength", float(r.strength)),
      ] |> Array.to_list,
    )

  let glyph = r =>
    object_(
      [
        ("id", string(r.id)),
        ("children", array(string, r.children)),
        ("encoding", raise(TODO)),
        ("fixedSize", bool(r.fixedSize)),
      ] |> Array.to_list,
    )

  let variables = Json.Encode.array(variable)

  let constraints = Json.Encode.array(constraint_)

  let glyphs = Json.Encode.array(glyph)

  let system = r =>
    object_(
      [
        ("variables", variables(r.variables)),
        ("constraints", constraints(r.constraints)),
        ("glyphs", glyphs(r.glyphs)),
      ] |> Array.to_list,
    )
}

module Decode = {
  open! Json.Decode

  exception DecodeError

  let strengthName = json =>
    switch string(json) {
    | "required" => Kiwi.Strength.required
    | "strong" => Kiwi.Strength.strong
    | "medium" => Kiwi.Strength.medium
    | "weak" => Kiwi.Strength.weak
    | _ => raise(DecodeError)
    }

  let strengthNum = json => float(json)

  let strength = either(strengthName, strengthNum)

  let varOpt = json =>
    switch json |> field("opt", string) {
    | "suggest" =>
      KiwiDeclarative.Suggest(json |> field("value", float), json |> field("strength", strength))
    | "stay" => Stay(json |> field("strength", strength))
    | "derived" => Derived
    | _ => raise(DecodeError)
    }

  let variable = json => {
    id: json |> field("id", string),
    varOpt: json |> field("varOpt", varOpt),
  }

  let rec aexpr = json =>
    switch json |> field("tag", string) {
    | "num" => Num(json |> field("value", float))
    | "var" => Var(json |> field("value", string))
    | "+" => Add(json |> field("ae1", aexpr), json |> field("ae2", aexpr))
    | "-" => Sub(json |> field("ae1", aexpr), json |> field("ae2", aexpr))
    | "*" => Mul(json |> field("ae1", aexpr), json |> field("f2", float))
    | "/" => Div(json |> field("ae1", aexpr), json |> field("f2", float))
    | _ => raise(DecodeError)
    }

  let cexpr = json =>
    switch json |> field("tag", string) {
    | "max" => Max(json |> field("aes", array(aexpr)))
    | "min" => Min(json |> field("aes", array(aexpr)))
    | _ => raise(DecodeError)
    }

  let expr = json =>
    switch json |> field("tag", string) {
    | "aexpr" => AExpr(json |> field("value", aexpr))
    | "cexpr" => CExpr(json |> field("value", cexpr))
    | _ => raise(DecodeError)
    }

  let operator = json =>
    switch string(json) {
    | "<=" | "le" => Le
    | ">=" | "ge" => Ge
    | "==" | "eq" => Eq
    | _ => raise(DecodeError)
    }

  let constraint_ = json => {
    lhs: json |> field("lhs", expr),
    op: json |> field("op", operator),
    rhs: json |> field("rhs", expr),
    strength: json |> field("strength", strength),
  }

  let glyph = json => {
    id: json |> field("id", string),
    children: json |> field("children", array(string)),
    encoding: json |> field("encoding", raise(TODO)),
    fixedSize: json |> field("fixedSize", bool),
  }

  let variables = Json.Decode.array(variable)

  let constraints = Json.Decode.array(constraint_)

  let glyphs = Json.Decode.array(glyph)

  let system = json => {
    variables: json |> field("variables", variables),
    constraints: json |> field("constraints", constraints),
    glyphs: json |> field("glyphs", glyphs),
  }
}

let unzip3List = xs =>
  List.fold_right(
    ((a, b, c), (as_, bs, cs)) => (list{a, ...as_}, list{b, ...bs}, list{c, ...cs}),
    xs,
    (list{}, list{}, list{}),
  )

let unzip3 = xs => {
  let (as_, bs, cs) = xs->Array.to_list->unzip3List
  (as_->Array.of_list, bs->Array.of_list, cs->Array.of_list)
}

module Layout = {
  let rec aexpr = ae =>
    switch ae {
    | Num(x) => KiwiBBox.Num(x)
    | Var(vid) => Var(vid)
    | Add(ae1, ae2) => Add(aexpr(ae1), aexpr(ae2))
    | Sub(ae1, ae2) => Sub(aexpr(ae1), aexpr(ae2))
    | Mul(ae1, f2) => Mul(aexpr(ae1), f2)
    | Div(ae1, f2) => Div(aexpr(ae1), f2)
    }

  // Currently uses simple encoding.
  let cexpr = ce =>
    switch ce {
    | Max(aes) => KiwiBBox.Max(Belt.Array.map(aes, aexpr))
    | Min(aes) => KiwiBBox.Min(Belt.Array.map(aes, aexpr))
    }

  let expr = e =>
    switch e {
    | AExpr(ae) => KiwiBBox.AExpr(aexpr(ae))
    | CExpr(ce) => CExpr(cexpr(ce))
    }

  let operator = op =>
    switch op {
    | Le => KiwiBBox.Le
    | Ge => KiwiBBox.Ge
    | Eq => KiwiBBox.Eq
    }

  let variable = ({id, varOpt}) => {KiwiBBox.id: id, varOpt: varOpt}

  let constraint_ = ({lhs, op, rhs, strength}) => {
    KiwiBBox.lhs: expr(lhs),
    op: operator(op),
    rhs: expr(rhs),
    strength: strength,
  }

  let glyph = ({id, children}) => {KiwiBBox.id: id, children: children}

  let measureNaturalDimensions = (g: glyph): (float, float) => {
    // TODO: feed in a smarter dummy encoding or cut the amount of bbox information sent to encoding
    let (naturalWidth, naturalHeight) = Measure.svg(
      "measurement-node",
      g.encoding({
        left: 0.,
        right: 0.,
        top: 0.,
        bottom: 0.,
        width: 1.,
        height: 1.,
        centerX: 0.,
        centerY: 0.,
        scaleX: 1.,
        scaleY: 1.,
      }),
    )
    // prevents nonzero values (e.g. canvas)
    // TODO: could switch encoding to an `option` and then only use this hack for Nones.
    (max(naturalWidth, 1.), max(naturalHeight, 1.))
  }

  let makeScaleVariablesAndConstraints = (g: glyph): (variables, constraints) => {
    let fixedSizeConstraints = if g.fixedSize {
      [
        {
          lhs: AExpr(Var(j`${g.id}.scaleX`)),
          op: Eq,
          rhs: AExpr(Num(1.)),
          strength: Kiwi.Strength.required,
        },
        {
          lhs: AExpr(Var(j`${g.id}.scaleY`)),
          op: Eq,
          rhs: AExpr(Num(1.)),
          strength: Kiwi.Strength.required,
        },
      ]
    } else {
      []
    }

    let (naturalWidth, naturalHeight) = measureNaturalDimensions(g)

    (
      [
        {
          id: j`${g.id}.scaleX`,
          varOpt: Derived /* TODO: suggest 1? */,
        },
        {
          id: j`${g.id}.scaleY`,
          varOpt: Derived /* TODO: suggest 1? */,
        },
      ],
      [
        {
          lhs: AExpr(Var(j`${g.id}.width`)),
          op: Eq,
          rhs: AExpr(Mul(Var(j`${g.id}.scaleX`), naturalWidth)),
          strength: Kiwi.Strength.required,
        },
        {
          lhs: AExpr(Var(j`${g.id}.height`)),
          op: Eq,
          rhs: AExpr(Mul(Var(j`${g.id}.scaleY`), naturalHeight)),
          strength: Kiwi.Strength.required,
        },
      ]->Belt.Array.concat(fixedSizeConstraints),
    )
  }

  let system = ({variables, constraints, glyphs}) => {
    open! Belt

    let (scaleVars, scaleConstraints) =
      glyphs->Array.map(makeScaleVariablesAndConstraints)->Array.unzip
    let scaleVars = Array.concatMany(scaleVars)
    let scaleConstraints = Array.concatMany(scaleConstraints)

    {
      KiwiBBox.variables: Array.concat(variables, scaleVars)->Array.map(variable),
      constraints: Array.concat(constraints, scaleConstraints)->Array.map(constraint_),
      bboxes: glyphs->Array.map(glyph),
    }
  }
}

// TODO: may want to restrict this input language a la Vega
// TODO: this needs to be rewritten properly for correct interop
type transformSettings = {plugins: array<string>}

type transformResult<'a, 'b, 'c> = {
  code: 'a,
  map: 'b,
  ast: 'c,
}

let render = system => {
  // Layout with KiwiBBox, then lower all the way to Kiwi, then solve.
  let varValues =
    system->Layout.system->KiwiBBox.Lower.system->KiwiMax.Lower.system->KiwiInterface.solve

  // Feed solver output to glyph encodings.
  //   Make the `encoding` string a function body that takes bbox fields as arguments. Call it with
  //   the bbox values returned by Kiwi. Use eval with Babel so it can handle JSX:
  //   https://stackoverflow.com/questions/33225951/evaling-code-with-jsx-syntax-in-it
  Js.log("glyphs")
  let renderedGlyphs = Array.map(({id, encoding}) =>
    encoding({
      left: varValues->Belt.HashMap.String.get(id ++ ".left")->Belt.Option.getExn,
      right: varValues->Belt.HashMap.String.get(id ++ ".right")->Belt.Option.getExn,
      top: varValues->Belt.HashMap.String.get(id ++ ".top")->Belt.Option.getExn,
      bottom: varValues->Belt.HashMap.String.get(id ++ ".bottom")->Belt.Option.getExn,
      width: varValues->Belt.HashMap.String.get(id ++ ".width")->Belt.Option.getExn,
      height: varValues->Belt.HashMap.String.get(id ++ ".height")->Belt.Option.getExn,
      centerX: varValues->Belt.HashMap.String.get(id ++ ".centerX")->Belt.Option.getExn,
      centerY: varValues->Belt.HashMap.String.get(id ++ ".centerY")->Belt.Option.getExn,
      scaleX: varValues->Belt.HashMap.String.get(id ++ ".scaleX")->Belt.Option.getExn,
      scaleY: varValues->Belt.HashMap.String.get(id ++ ".scaleY")->Belt.Option.getExn,
    })
  , system.glyphs) // TODO: feed varValues in
  // Concatenate all the glyphs and return a React element
  <svg width="500" height="500"> {renderedGlyphs->React.array} </svg>
}
