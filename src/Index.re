// Entry point

[@bs.val] external document: Js.t({..}) = "document";

// We're using raw DOM manipulations here, to avoid making you read
// ReasonReact when you might precisely be trying to learn it for the first
// time through the examples later.
let style = document##createElement("style");
document##head##appendChild(style);
style##innerHTML #= ExampleStyles.style;

let makeContainer = text => {
  let container = document##createElement("div");
  container##className #= "container";

  let title = document##createElement("div");
  title##className #= "containerTitle";
  title##innerText #= text;

  let content = document##createElement("div");
  content##className #= "containerContent";

  let () = container##appendChild(title);
  let () = container##appendChild(content);
  let () = document##body##appendChild(container);

  content;
};

// ReactDOMRe.render(
//   KiwiGlyph.render(
//     Semantic3.toGestalt(
//       BipartiteThreeStructures.semanticSystem,
//       BipartiteThreeStructures.semanticEncoding,
//     )
//     ->Gestalt2.Lower.system,
//   ),
//   makeContainer("Bipartite Graph Three Structures Test"),
// );

// ReactDOMRe.render(
//   <DisplayBox system=PenroseMap.semanticSystem encoding=PenroseMap.semanticEncoding />,
//   makeContainer("Penrose Map Test"),
// );

ReactDOMRe.render(
  KiwiGlyph.render(
    Semantic3.toGestalt(PythonTutorFullTuple.semanticSystem, PythonTutorFullTuple.semanticEncoding)
    ->Gestalt2.Lower.system,
  ),
  makeContainer("Python Tutor Full Tuple"),
);

ReactDOMRe.render(
  KiwiGlyph.render(
    Semantic3.toGestalt(PythonTutorSimple.semanticSystem, PythonTutorSimple.semanticEncoding)
    ->Gestalt2.Lower.system,
  ),
  makeContainer("Python Tutor"),
);

Js.log(StackedBarChart.semanticSystem->Semantic3.semanticSystemToJson->Js.Json.stringifyWithSpace(2));
Js.log2("stacked bar chart", StackedBarChart.semanticSystem->Semantic3.semanticSystemToJson->Js.Json.stringifyWithSpace(2));
Js.log2("bar chart", BarChart.semanticSystem->Semantic3.semanticSystemToJson->Js.Json.stringifyWithSpace(2));

ReactDOMRe.render(
  KiwiGlyph.render(
    Semantic3.toGestalt(StackedBarChart.semanticSystem, StackedBarChart.semanticEncoding)
    ->Gestalt2.Lower.system,
  ),
  makeContainer("Stacked Bar Chart"),
);

ReactDOMRe.render(
  KiwiGlyph.render(
    Semantic3.toGestalt(BarChart.semanticSystem, BarChart.semanticEncoding)
    ->Gestalt2.Lower.system,
  ),
  makeContainer("Bar Chart"),
);

ReactDOMRe.render(
  KiwiGlyph.render(
    Semantic3.toGestalt(PenroseMap.semanticSystem, PenroseMap.semanticEncoding)
    ->Gestalt2.Lower.system,
  ),
  makeContainer("Penrose Map Test"),
);

ReactDOMRe.render(
  KiwiGlyph.render(
    Semantic3.toGestalt(PowerSet.semanticSystem, PowerSet.semanticEncoding)
    ->Gestalt2.Lower.system,
  ),
  makeContainer("Power Set Test"),
);

ReactDOMRe.render(
  KiwiGlyph.render(
    Semantic3.toGestalt(
      BipartiteOneStructure.semanticSystem,
      BipartiteOneStructure.semanticEncoding,
    )
    ->Gestalt2.Lower.system,
  ),
  makeContainer("Bipartite Graph One Structure Test"),
);

ReactDOMRe.render(
  KiwiGlyph.render(
    Semantic3.toGestalt(
      TreeLayoutNodeLinkSemantic3.semanticSystem,
      TreeLayoutNodeLinkSemantic3.semanticEncoding,
    )
    ->Gestalt2.Lower.system,
  ),
  makeContainer("Semantic3 Node-Link Tree Test"),
);

ReactDOMRe.render(
  KiwiGlyph.render(
    Semantic3.toGestalt(
      TreeLayoutIcicleSemantic3.semanticSystem,
      TreeLayoutIcicleSemantic3.semanticEncoding,
    )
    ->Gestalt2.Lower.system,
  ),
  makeContainer("Semantic3 Icicle Tree Test"),
);

ReactDOMRe.render(
  KiwiGlyph.render(
    Semantic3.toGestalt(
      TextLayoutSemantic3Different.semanticSystem,
      TextLayoutSemantic3Different.semanticEncoding,
    )
    ->Gestalt2.Lower.system,
  ),
  makeContainer("Semantic3 Test"),
);
ReactDOMRe.render(
  KiwiGlyph.render(
    Semantic3.toGestalt(
      TextLayoutSemantic3Similar.semanticSystem,
      TextLayoutSemantic3Similar.semanticEncoding,
    )
    ->Gestalt2.Lower.system,
  ),
  makeContainer("Semantic3 Test"),
);
ReactDOMRe.render(
  KiwiGlyph.render(
    Semantic3.toGestalt(TextLayoutSemantic3.semanticSystem, TextLayoutSemantic3.semanticEncoding)
    ->Gestalt2.Lower.system,
  ),
  makeContainer("Semantic3 Test"),
);

// ReactDOMRe.render(
//   KiwiGlyph.render(TreeLayoutIcicle.system->Gestalt2.Lower.system),
//   makeContainer("Tree Layout Icicle"),
// );

// ReactDOMRe.render(
//   KiwiGlyph.render(TreeLayoutRevised.system->Gestalt2.Lower.system),
//   makeContainer("Tree Layout Revised"),
// );

// ReactDOMRe.render(
//   KiwiGlyph.render(
//     Semantic2.toGestalt(TextLayoutSemantic2.semanticSystem, TextLayoutSemantic2.gestaltEncoding)
//     ->Gestalt2.Lower.system,
//   ),
//   makeContainer("Semantic2 Test"),
// );

// ReactDOMRe.render(
//   KiwiGlyph.render(
//     Semantic.toGestalt(TextLayoutSemantic.semanticSystem, TextLayoutSemantic.gestaltEncoding)
//     ->Gestalt2.Lower.system,
//   ),
//   makeContainer("Semantic Test"),
// );

// ReactDOMRe.render(
//   KiwiGlyph.render(TreeLayout.system->Gestalt2.Lower.system),
//   makeContainer("Tree Layout"),
// );

ReactDOMRe.render(
  KiwiGlyph.render(TextLayoutGestaltCenteredDifferent.system->Gestalt2.Lower.system),
  makeContainer("Text Layout Gestalt Centered Different"),
);

ReactDOMRe.render(
  KiwiGlyph.render(TextLayoutGestaltInline.system->Gestalt2.Lower.system),
  makeContainer("Text Layout Gestalt Inline"),
);

ReactDOMRe.render(
  KiwiGlyph.render(TextLayoutGestaltCentered.system->Gestalt2.Lower.system),
  makeContainer("Text Layout Gestalt Centered"),
);

// ReactDOMRe.render(
//   KiwiGlyph.render(TextLayoutGestalt.system->Gestalt2.Lower.system),
//   makeContainer("Text Layout Gestalt"),
// );

// // ReactDOMRe.render(KiwiGlyph.render(TextLayout.system), makeContainer("Text Layout"));

// ReactDOMRe.render(KiwiGlyph.render(SquareInCircle.system), makeContainer("Square in Circle"));

// // ReactDOMRe.render(KiwiGlyph.render(Simple.system), makeContainer("Simple Test"));

// // ReactDOMRe.render(
// //   KiwiGlyph.render(
// //     Semantic2.toGestalt(TreeLayoutSemantic.semanticSystem, TreeLayoutSemantic.gestaltEncoding)
// //     ->Gestalt2.Lower.system,
// //   ),
// //   makeContainer("Tree Layout Semantic Test"),
// // );

// // // All 4 examples.
// // ReactDOMRe.render(
// //   <BlinkingGreeting>
// //     {React.string("Hello!")}
// //   </BlinkingGreeting>,
// //   makeContainer("Blinking Greeting"),
// // );

// // ReactDOMRe.render(
// //   <ReducerFromReactJSDocs />,
// //   makeContainer("Reducer From ReactJS Docs"),
// // );

// // ReactDOMRe.render(
// //   <FetchedDogPictures />,
// //   makeContainer("Fetched Dog Pictures"),
// // );

// // ReactDOMRe.render(
// //   <ReasonUsingJSUsingReason />,
// //   makeContainer("Reason Using JS Using Reason"),
// // );
