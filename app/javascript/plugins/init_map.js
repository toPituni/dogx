// some initial functions for the styling / interactions of the map from HERE
// function for the infowindow bubbles
const onBubbleTap = (evt) =>  {
  let bubble;
  // calculate infobubble position from the cursor screen coordinates
  let position = newMap.screenToGeo(
    evt.currentPointer.viewportX,
    evt.currentPointer.viewportY
  );
  // read the properties associated with the map feature that triggered the event
  let props = evt.target.getData().properties;
  // create a content for the infobubble
  let content = 'It is a ' + props.kind + ' ' + (props.kind_detail || '') +
    (props.population ? ' population: ' + props.population : '') + ' local name is ' + props['name'] + (props['name:ar'] ? 'name in Arabic is '+ props['name:ar'] : '') + '';
  // Create a bubble, if not created yet
  if (!bubble) {
    bubble = new H.ui.InfoBubble(position, {
      content: content
    });
    ui.addBubble(bubble);
  } else {
    // Reuse existing bubble object
    bubble.setPosition(position);
    bubble.setContent(content);
    bubble.open();
  }
}
// setting the interactive layers for the map(satellite, etc)
const setInteractive = (map) => {
  // get the vector provider from the base layer
  const provider = map.getBaseLayer().getProvider();
  // get the style object for the base layer
  const style = provider.getStyle();
  const changeListener = (evt) => {
    if (style.getState() === H.map.Style.State.READY) {
      style.removeEventListener('change', changeListener);
      // enable interactions for the desired map features
      style.setInteractive(['places', 'places.populated-places'], true);
      // add an event listener that is responsible for catching the
      // 'tap' event on the feature and showing the infobubble
      provider.addEventListener('tap', onBubbleTap);
    }
  };
  style.addEventListener('change', changeListener);
}
// our code to deal with API responses and creating the map



// we have access to map element.dataset.markers returns the array of lat lng objects
const drawRoute = (result, map) => {
  let route,
    routeShape,
    startPoint,
    endPoint,
    linestring;
  if(result.response.route) {
  // Pick the first route from the response:
  route = result.response.route[0];
  console.log(route);
  // Pick the route's shape:
  routeShape = route.shape;
  // Create a linestring to use as a point source for the route line
  linestring = new H.geo.LineString();
  // Push all the points in the shape into the linestring:
  routeShape.forEach((point) => {
    const parts = point.split(',');
    linestring.pushLatLngAlt(parts[0], parts[1]);
  });
  // Retrieve the mapped positions of the requested waypoints:
  startPoint = route.waypoint[0].mappedPosition;
  endPoint = route.waypoint[1].mappedPosition;
  // Create a polyline to display the route:
  const routeLine = new H.map.Polyline(linestring, {
    style: { strokeColor: 'blue', lineWidth: 3 }
  });
  // Create a marker for the start point:
  const startMarker = new H.map.Marker({
    lat: startPoint.latitude,
    lng: startPoint.longitude
  });
  // Create a marker for the end point:
  const endMarker = new H.map.Marker({
    lat: endPoint.latitude,
    lng: endPoint.longitude
  });
  // Add the route polyline and the two markers to the map:
  map.addObjects([routeLine, startMarker, endMarker]);
  // Set the map's viewport to make the whole route visible:
  map.getViewModel().setLookAtData({bounds: routeLine.getBoundingBox()});
  }
};

const addResponseToMap = (map, platform) => {
  const startingPoint = [52.5160, 13.3779]
  const firstStop = [52.5206, 13.3862]
  const secondStop = [52.51293,13.24021]
  const thirdStop = [52.53066,13.38511]
  const representation = "display";
  const mode = ["fastest","car","traffic"]
  const key = "kRsg1jkH1P-VUi-_G_I8_ju8YGs9GZasZIg_3_7q6gA"
  const departure = "now"
  const baseUrl = 'https://route.ls.hereapi.com/routing/7.2/calculateroute.json?';
  const endpoint = `https://route.ls.hereapi.com/routing/7.2/calculateroute.json?waypoint0=${startingPoint[0]},${startingPoint[1]}&waypoint1=${firstStop[0]}%2C${firstStop[1]}&waypoint2=${secondStop[0]}%2C${secondStop[1]}&waypoint3=${thirdStop[0]}%2C${thirdStop[1]}&representation=${representation}&mode=${mode[0]}%3B${mode[1]}%3B${mode[2]}%3Aenabled&departure=${departure}&apiKey=${key}`
  // const endpoint = 'https://wse.ls.hereapi.com/2/findsequence.json?start=Berlin-Main-Station;52.52282,13.37011&destination1=East-Side-Gallery;52.50341,13.44429&destination2=Olympiastadion;52.51293,13.24021&end=HERE-Berlin-Campus;52.53066,13.38511&mode=fastest;car&apiKey=kRsg1jkH1P-VUi-_G_I8_ju8YGs9GZasZIg_3_7q6gA';
   fetch(endpoint)
    .then(response => response.json())
    .then((data) => {
      console.log(data);
      drawRoute(data, map);
      // addRoutingToMap(data, map, platform)
       // data["results"][0]["waypoints"].forEach((result) => {
       //    const coordinates = { lat: result["lat"], lng: result["lng"]};
       //    const dogMarker = new H.map.Marker(coordinates);
       //    map.addObject(dogMarker);
       //  });
      });
};

const createMapElement = (defaultLayers) => {
  //Step 2: initialize a map
  const map = new H.Map(document.getElementById('map'),
    defaultLayers.vector.normal.map, {
    center: {lat: 52.51477270923461, lng: 13.39846691425174},
    zoom: 13,
    pixelRatio: window.devicePixelRatio || 1
  });
  const ui = H.ui.UI.createDefault(map, defaultLayers);
  return map;
};
const initMap = () => {
  const platform = new H.service.Platform({
    apikey: 'kRsg1jkH1P-VUi-_G_I8_ju8YGs9GZasZIg_3_7q6gA'
  });
  const defaultLayers = platform.createDefaultLayers();
  const newMap = createMapElement(defaultLayers);
  addResponseToMap(newMap, platform);
  // addRoutingToMap(newMap, platform);
  window.addEventListener('resize', () => newMap.getViewPort().resize());
  // Behavior implements default interactions for pan/zoom (also on mobile touch environments)
  const behavior = new H.mapevents.Behavior(new H.mapevents.MapEvents(newMap));
  setInteractive(newMap);
}
export { initMap };
