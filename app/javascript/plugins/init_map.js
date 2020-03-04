
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
  var platform = new H.service.Platform({
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
}


const initMap = () => {
  createMapElement();


/**
 * Boilerplate map initialization code starts below:
 */

//Step 1: initialize communication with the platform
// In your own code, replace variable window.apikey with your own apikey

// add a resize listener to make sure that the map occupies the whole container
window.addEventListener('resize', () => map.getViewPort().resize());

//Step 3: make the map interactive
// MapEvents enables the event system
// Behavior implements default interactions for pan/zoom (also on mobile touch environments)
var behavior = new H.mapevents.Behavior(new H.mapevents.MapEvents(map));

// Create the default UI components
var ui = H.ui.UI.createDefault(map, defaultLayers);

var map2 = document.getElementById('map');
var dogMarkers = JSON.parse(map2.dataset.markers);
if (map) {
  dogMarkers.forEach((marker) => {
  const dogMarker = new H.map.Marker(marker);
  map.addObject(dogMarker);
  })
};

// EVERYTHING BELOW IS REGARDING INFO BUBBLE //

var bubble;
/**
 * @param {H.mapevents.Event} e The event object
 */
function onTap(evt) {
  // calculate infobubble position from the cursor screen coordinates
  let position = map.screenToGeo(
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
setInteractive(map);
}

export { initMap };
