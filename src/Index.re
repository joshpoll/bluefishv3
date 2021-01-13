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

ReactDOMRe.render(KiwiGlyph.render(Simple.system), makeContainer("Simple Test"));

ReactDOMRe.render(KiwiGlyph.render(SquareInCircle.system), makeContainer("Square in Circle"));

ReactDOMRe.render(KiwiGlyph.render(TextLayout.system), makeContainer("Text Layout"));

ReactDOMRe.render(
  KiwiGlyph.render(TextLayoutGestalt.system->Gestalt.Lower.system),
  makeContainer("Text Layout Gestalt"),
);

ReactDOMRe.render(
  KiwiGlyph.render(TextLayoutGestaltCentered.system->Gestalt.Lower.system),
  makeContainer("Text Layout Gestalt Centered"),
);

ReactDOMRe.render(
  KiwiGlyph.render(TextLayoutGestaltInline.system->Gestalt.Lower.system),
  makeContainer("Text Layout Gestalt Inline"),
);

ReactDOMRe.render(
  KiwiGlyph.render(TreeLayout.system->Gestalt.Lower.system),
  makeContainer("Tree Layout"),
);

ReactDOMRe.render(
  KiwiGlyph.render(
    Semantic.toGestalt(Semantic.exampleSemanticSystem, Semantic.exampleGestaltEncoding)
    ->Gestalt.Lower.system,
  ),
  makeContainer("Semantic Test"),
);

// // All 4 examples.
// ReactDOMRe.render(
//   <BlinkingGreeting>
//     {React.string("Hello!")}
//   </BlinkingGreeting>,
//   makeContainer("Blinking Greeting"),
// );

// ReactDOMRe.render(
//   <ReducerFromReactJSDocs />,
//   makeContainer("Reducer From ReactJS Docs"),
// );

// ReactDOMRe.render(
//   <FetchedDogPictures />,
//   makeContainer("Fetched Dog Pictures"),
// );

// ReactDOMRe.render(
//   <ReasonUsingJSUsingReason />,
//   makeContainer("Reason Using JS Using Reason"),
// );
