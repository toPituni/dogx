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

const calculateRoute = (map, platform) => {

}

const addRouteToMap = (result, map) => {
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
  endPoint = route.waypoint[3].mappedPosition;
  const dogStops = []
  route.waypoint.forEach((waypoint) => {
    const marker = new H.map.Marker({
      lat: waypoint.mappedPosition.latitude,
      lng: waypoint.mappedPosition.longitude
    });
    map.addObject(marker);
    dogStops.push(marker);
  });
  console.log(dogStops)
  // Create a polyline to display the route:
  const routeLine = new H.map.Polyline(linestring, {
    style: { strokeColor: 'blue', lineWidth: 3 }
  });
    // // Add the route polyline and the two markers to the map:
  map.addObject(routeLine);
  // Set the map's viewport to make the whole route visible:
  map.getViewModel().setLookAtData({bounds: routeLine.getBoundingBox()});
  }
};

const div = document.getElementById("map");
const dogCoordinates = JSON.parse(div.dataset.coordinates)
const userAddress = JSON.parse(div.dataset.userAddress)
const addResponseToMap = (map) => {

  const startingPoint = [dogCoordinates[0], dogCoordinates[0]]
  const firstStop = [dogCoordinates[1], dogCoordinates[1]]
  const secondStop = [dogCoordinates[2], dogCoordinates[2]]
  const thirdStop = [dogCoordinates[3], dogCoordinates[3]]
  const representation = "display"
  const mode = ["fastest","car","traffic"]
  const apiKey = "kRsg1jkH1P-VUi-_G_I8_ju8YGs9GZasZIg_3_7q6gA"
  const departure = "now"
  const baseSequenceUrl = 'https://wse.ls.hereapi.com/2/findsequence.json?'
  const baseRouteUrl = 'https://route.ls.hereapi.com/routing/7.2/calculateroute.json?';
  const sequenceEndpoint = `${baseSequenceUrl}start=${startingPoint[0]},${startingPoint[1]}&destination1=${firstStop[0]}%2C${firstStop[1]}&destination2=${secondStop[0]}%2C${secondStop[1]}&end=${thirdStop[0]}%2C${thirdStop[1]}&representation=${representation}&mode=${mode[0]};${mode[1]}&apiKey=${apiKey}`
  const routeEndpoint = `${baseRouteUrl}waypoint0=${startingPoint[0]},${startingPoint[1]}&waypoint1=${firstStop[0]}%2C${firstStop[1]}&waypoint2=${secondStop[0]}%2C${secondStop[1]}&waypoint3=${thirdStop[0]}%2C${thirdStop[1]}&representation=${representation}&mode=${mode[0]}%3B${mode[1]}%3B${mode[2]}%3Aenabled&departure=${departure}&apiKey=${apiKey}`
 fetch(sequenceEndpoint)
  .then(response => response.json())
  .then((data) => {
    console.log(data);
    addRouteToMap(data, map)
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
  addResponseToMap(newMap);

  // addRoutingToMap(newMap, platform);
  window.addEventListener('resize', () => newMap.getViewPort().resize());
  // Behavior implements default interactions for pan/zoom (also on mobile touch environments)
  const behavior = new H.mapevents.Behavior(new H.mapevents.MapEvents(newMap));
  setInteractive(newMap);
}
export { initMap };
