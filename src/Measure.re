[@bs.val] external document: Js.t({..}) = "document";

let svg = (id: string, e: React.element) => {
  // https://stackoverflow.com/a/63984284
  // https://stackoverflow.com/a/3492557
  let xmlns = "http://www.w3.org/2000/svg";
  let width = "1000";
  let height = "1000";

  /* create svg */
  let newSVG = document##createElementNS(xmlns, "svg");
  newSVG##setAttribute("id", id ++ "-svg");
  newSVG##setAttributeNS(Js.null, "viewBox", "0 0 " ++ width ++ " " ++ height);
  newSVG##setAttributeNS(Js.null, "width", width);
  newSVG##setAttributeNS(Js.null, "height", height);

  /* create g */
  let newG = document##createElementNS(xmlns, "g");
  newG##setAttribute("id", id ++ "-g");
  newSVG##appendChild(newG);

  /* append svg to DOM */
  document##body##appendChild(newSVG);

  /* render e */
  let domG = document##getElementById(id ++ "-g");
  ReactDOM.render(e, domG);

  /* measure g */
  let width = domG##getBoundingClientRect()##width;
  let height = domG##getBoundingClientRect()##height;

  /* clean up */
  let domSVG = document##getElementById(id ++ "-svg");
  // TODO: this produces a warning, though we may be fine with ignoring it.
  ReactDOM.unmountComponentAtNode(domSVG); // Clean up React
  domSVG##parentNode##removeChild(domSVG); // Clean up DOM

  (width, height);
};