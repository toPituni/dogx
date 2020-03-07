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
  const provider = map.getBaseLayer().getProvider();
  const style = provider.getStyle();
  const changeListener = (evt) => {
    if (style.getState() === H.map.Style.State.READY) {
      style.removeEventListener('change', changeListener);
      style.setInteractive(['places', 'places.populated-places'], true);
      // provider.addEventListener('tap', onBubbleTap);
    }
  };
  style.addEventListener('change', changeListener);
}

// our code to deal with API responses and creating the map
const addRouteToMap = (result, map) => {
  let route,
    routeShape,
    startPoint,
    endPoint,
    linestring;
  if(result.response.route) {
  // Pick the first route from the response:
  route = result.response.route[0];
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
  const dogStops = []
  route.waypoint.forEach((waypoint) => {
    const marker = new H.map.Marker({
      lat: waypoint.mappedPosition.latitude,
      lng: waypoint.mappedPosition.longitude
    });
    map.addObject(marker);
    dogStops.push(marker);
  });
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
const dogCoordinates = JSON.parse(div.dataset.coordinates);
const userAddress = JSON.parse(div.dataset.userAddress);
const destination = JSON.parse(div.dataset.destination);

const fetchRoute = (data, map) => {
  const apiKey = "kRsg1jkH1P-VUi-_G_I8_ju8YGs9GZasZIg_3_7q6gA";
  let routeEndpoint = `https://route.ls.hereapi.com/routing/7.2/calculateroute.json?waypoint0=${userAddress.join(',')}`;
  const waypoints = data.results[0].waypoints;
  for ( let i = 0; i < waypoints.length; i++) {
    routeEndpoint += `&waypoint${i+1}=${waypoints[i].lat},${waypoints[i].lng}`;
  }
  routeEndpoint += `&representation=display&mode=fastest;car&departure=now&apiKey=${apiKey}`;
  fetch(routeEndpoint)
  .then(response => response.json())
  .then((data) => {
    console.log(data);
    addRouteToMap(data, map);
  });
}

const fetchSequence = (map) => {
  const apiKey = "kRsg1jkH1P-VUi-_G_I8_ju8YGs9GZasZIg_3_7q6gA";
  let sequenceEndpoint = `https://wse.ls.hereapi.com/2/findsequence.json?start=${userAddress.join(',')}`;
  for (let [key, value] of Object.entries(dogCoordinates)) {
    sequenceEndpoint += `&destination${key+1}=${value}`
  };
  const dogCoordsLength = Object.keys(dogCoordinates).length;
  if (destination) {
    sequenceEndpoint += `&destination${dogCoordsLength + 1}=${destination.join(',')}`;
  };
  sequenceEndpoint += `&mode=fastest;car&departure=now&apiKey=${apiKey}`;
  fetch(sequenceEndpoint)
  .then(response => response.json())
  .then((data) => {
    fetchRoute(data, map);
  });
}

const createMapElement = (defaultLayers) => {
  const map = new H.Map(document.getElementById('map'),
    defaultLayers.vector.normal.map, {
    center: {lat: 52.51477270923461, lng: 13.39846691425174},
    zoom: 13,
    pixelRatio: window.devicePixelRatio || 1
  });
  const ui = H.ui.UI.createDefault(map, defaultLayers);

  var mapSettings = ui.getControl('mapsettings');
var zoom = ui.getControl('zoom');
var scalebar = ui.getControl('scalebar');

  mapSettings.setAlignment('top-left');
  zoom.setAlignment('top-left');
  scalebar.setAlignment('top-left');
  return map;

};

const initMap = () => {
  const platform = new H.service.Platform({
    apikey: 'kRsg1jkH1P-VUi-_G_I8_ju8YGs9GZasZIg_3_7q6gA'
  });
  const defaultLayers = platform.createDefaultLayers();
  const newMap = createMapElement(defaultLayers);
  fetchSequence(newMap);
  window.addEventListener('resize', () => newMap.getViewPort().resize());
  // Behavior implements default interactions for pan/zoom (also on mobile touch environments)
  const behavior = new H.mapevents.Behavior(new H.mapevents.MapEvents(newMap));
  setInteractive(newMap);
}

export { initMap };
