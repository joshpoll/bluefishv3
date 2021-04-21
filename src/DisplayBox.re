// Put your diagrams on display!

[@react.component]
let make = (~system, ~encoding) => {
  let (render, setRender) = React.useState(() => false);

  let handleClick = _e => setRender(r => !r);

  <>
    <div> <button onClick=handleClick> {React.string("Render me!")} </button> </div>
    {if (render) {
       <div>
         {Semantic3.toGestalt(system, encoding)->Gestalt2.Lower.system->KiwiGlyph.render}
       </div>;
     } else {
       <> </>;
     }}
  </>;
};
