const addResponseToMap = (map) => {
 // console.log(map);
 const endpoint = 'https://wse.ls.hereapi.com/2/findsequence.json?start=Berlin-Main-Station;52.52282,13.37011&destination1=East-Side-Gallery;52.50341,13.44429&destination2=Olympiastadion;52.51293,13.24021&end=HERE-Berlin-Campus;52.53066,13.38511&mode=fastest;car&apiKey=kRsg1jkH1P-VUi-_G_I8_ju8YGs9GZasZIg_3_7q6gA'

 fetch(endpoint)
  .then(response => response.json())
  .then((data) => {
    console.log(data);

   data["results"][0]["waypoints"].forEach((result) => {
      //console.log(result);

      const coordinates = { lat: result["lat"], lng: result["lng"]};
      // const coordinates1 = [50.11562, 8.63121]
      // console.log(coordinates);
      // console.log(coordinates1);

      const dogMarker = new H.map.Marker(coordinates);
      // const dogMarker1 = new H.map.Marker({"lat":result["lat"],"lng":result["lng"]});
      // console.log(dogMarker)
      // console.log(dogMarker1)
      map.addObject(dogMarker);
    });
   });
  };

function setInteractive(map){
  // get the vector provider from the base layer
  var provider = map.getBaseLayer().getProvider();

  // get the style object for the base layer
  var style = provider.getStyle();

  var changeListener = (evt) => {
    if (style.getState() === H.map.Style.State.READY) {
      style.removeEventListener('change', changeListener);

      // enable interactions for the desired map features
      style.setInteractive(['places', 'places.populated-places'], true);

      // add an event listener that is responsible for catching the
      // 'tap' event on the feature and showing the infobubble
      provider.addEventListener('tap', onTap);
    }
  };
  style.addEventListener('change', changeListener);
}

const createMapElement = () => {
  const platform = new H.service.Platform({
      apikey: 'kRsg1jkH1P-VUi-_G_I8_ju8YGs9GZasZIg_3_7q6gA'
    });
    var defaultLayers = platform.createDefaultLayers();

    //Step 2: initialize a map
    var map = new H.Map(document.getElementById('map'),
      defaultLayers.vector.normal.map, {
      center: {lat: 52.51477270923461, lng: 13.39846691425174},
      zoom: 13,
      pixelRatio: window.devicePixelRatio || 1
    });
  var ui = H.ui.UI.createDefault(map, defaultLayers);
    // -------------------------- ROUTING IMPLEMENTATION -------------------------- //

// Create the parameters for the routing request:
var routingParameters = {
  // The routing mode:
  'mode': 'fastest;car',
  // The start point of the route:
  'waypoint1': 'geo!52.1120423728813,13.68340740740811',
  'waypoint2': 'geo!52.3120423728813,13.58340740740811',
  // The end point of the route:
  'waypoint0': 'geo!52.5309916298853,13.3846220493377',
  // To retrieve the shape of the route we choose the route
  // representation mode 'display'
  'representation': 'display'
};

// Define a callback function to process the routing response:
var onResult = function(result) {
  var route,
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
  routeShape.forEach(function(point) {
    var parts = point.split(',');
    linestring.pushLatLngAlt(parts[0], parts[1]);
  });

  // Retrieve the mapped positions of the requested waypoints:
  startPoint = route.waypoint[0].mappedPosition;
  endPoint = route.waypoint[1].mappedPosition;

  // Create a polyline to display the route:
  var routeLine = new H.map.Polyline(linestring, {
    style: { strokeColor: 'blue', lineWidth: 3 }
  });

  // Create a marker for the start point:
  var startMarker = new H.map.Marker({
    lat: startPoint.latitude,
    lng: startPoint.longitude
  });

  // Create a marker for the end point:
  var endMarker = new H.map.Marker({
    lat: endPoint.latitude,
    lng: endPoint.longitude
  });

  // Add the route polyline and the two markers to the map:
  map.addObjects([routeLine, startMarker, endMarker]);

  // Set the map's viewport to make the whole route visible:
  map.getViewModel().setLookAtData({bounds: routeLine.getBoundingBox()});
  }
};
// Get an instance of the routing service:
var router = platform.getRoutingService();

// Call calculateRoute() with the routing parameters,
// the callback and an error callback function (called if a
// communication error occurs):
router.calculateRoute(routingParameters, onResult,
  function(error) {
    alert(error.message);
  });


    return map;
};

const initMap = () => {
  const newMap = createMapElement();
  addResponseToMap(newMap);

/**
 * Boilerplate map initialization code starts below:
 */

//Step 1: initialize communication with the platform
// In your own code, replace variable window.apikey with your own apikey

// add a resize listener to make sure that the map occupies the whole container
window.addEventListener('resize', () => newMap.getViewPort().resize());

//Step 3: make the map interactive
// MapEvents enables the event system
// Behavior implements default interactions for pan/zoom (also on mobile touch environments)
var behavior = new H.mapevents.Behavior(new H.mapevents.MapEvents(newMap));

// Create the default UI components



// EVERYTHING BELOW IS REGARDING INFO BUBBLE //

var bubble;
/**
 * @param {H.mapevents.Event} e The event object
 */
function onTap(evt) {
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

// Now use the map as required...
setInteractive(newMap);
}


// -------------------------- ROUTING IMPLEMENTATION -------------------------- //

export { initMap };

