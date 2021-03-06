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
// const setInteractive = (map) => {
//   const provider = map.getBaseLayer().getProvider();
//   const style = provider.getStyle();
//   const changeListener = (evt) => {
//     if (style.getState() === H.map.Style.State.READY) {
//       style.removeEventListener('change', changeListener);
//       style.setInteractive(['places', 'places.populated-places'], true);
//       // provider.addEventListener('tap', onBubbleTap);
//     }
//   };
//   style.addEventListener('change', changeListener);
// }

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
  // const routeLine = new H.map.Polyline(linestring, {
  //   style: { strokeColor: 'blue', lineWidth: 3 }
  // });
  //   // // Add the route polyline and the two markers to the map:
  // map.addObject(routeLine);

  var routeOutline = new H.map.Polyline(linestring, {
  style: {
    lineWidth: 10,
    strokeColor: 'rgba(0, 128, 255, 0.7)',
    lineTailCap: 'arrow-tail',
    lineHeadCap: 'arrow-head'
  }
});
// Create a patterned polyline:
var routeArrows = new H.map.Polyline(linestring, {
  style: {
    lineWidth: 10,
    fillColor: 'white',
    strokeColor: 'rgba(255, 255, 255, 1)',
    lineDash: [0, 2],
    lineTailCap: 'arrow-tail',
    lineHeadCap: 'arrow-head' }
  }
);

var routeLine = new H.map.Group();
routeLine.addObjects([routeOutline, routeArrows]);
map.addObject(routeLine);

  // Set the map's viewport to make the whole route visible:
  map.getViewModel().setLookAtData({bounds: routeLine.getBoundingBox()});
  }
};

const mapDiv = document.getElementById("map");
let dogCoordinates;
let userAddress;
let destination;
let dogInfo;
if (mapDiv) {
  dogCoordinates = JSON.parse(mapDiv.dataset.coordinates);
  userAddress = JSON.parse(mapDiv.dataset.userAddress);
  destination = JSON.parse(mapDiv.dataset.destination);
  dogInfo = JSON.parse(mapDiv.dataset.dogInformation);
}
console.log(dogInfo)
let responseCoords = []
const addDirectionsToMap = (data, map) => {
  const navigationCards = document.getElementById('accordionExample')
  const instructionList = document.getElementById('instructions-list')
  let count = 1;
  data.response.route[0].leg.map((legs) => {
    if (data.response.route[0].leg.indexOf(legs) !== 0) {
      let currentDog;
      const responseCoords = [legs.maneuver[0].position.latitude.toFixed(3),legs.maneuver[0].position.longitude.toFixed(3)];
      dogInfo.forEach((dog, index) => {
        let coords = dog.coords;
        coords = [coords[0].toFixed(3), coords[1].toFixed(3)]
        if (responseCoords.join(',') === coords.join(',')) {
          currentDog = dogInfo[index];
        }
      });
      navigationCards.insertAdjacentHTML("beforeend", `<div class="card"><div class="card-header" id="heading${count}"><h5 class="mb-0"><button class="btn btn-link" style="color: black; text-decoration: none;" type="button" data-toggle="collapse" data-target="#collapse${count}" aria-expanded="true" aria-controls="collapse${count}">Navigation to stop ${count}</button></h5></div>`)
      let listString = "";
      legs.maneuver.forEach((leg) => {
        listString += `<li>${leg.instruction}</li>`;
      });
      navigationCards.insertAdjacentHTML("beforeend", `<div id="collapse${count}" class="collapse" aria-labelledby="heading${count}" data-parent="#accordionExample"><div class="card-body"><ul id='instructions-list'>${listString}</ul></div></div></div>`)
      count ++;
    }
  });
};


(function() {
  const toggleMap = document.getElementById('toggle-map');
  if (toggleMap) {
    function mapToggleEvent() {
      const map = document.getElementById('map');
      const mapContainer = document.querySelector('.mapDiv')
      const infoIcon = document.querySelector('.info-icon');
      const mapIcon = document.querySelector('.map-icon');
      // debugger;

      if (mapIcon) {
        mapIcon.remove();
        toggleMap.insertAdjacentHTML("afterbegin", `<i class="fas fa-info map-info-icon info-icon" id="toggle-map"></i>`);
      };

      if (infoIcon) {
        infoIcon.remove();
        toggleMap.insertAdjacentHTML("afterbegin", `<i class="fas fa-map-marked-alt map-info-icon map-icon" id="toggle-map"></i>`);
      };

      map.style.visibility = map.style.visibility === 'hidden' ? 'visible' : "hidden";
      const list = document.getElementById('accordionExample');
      // debugger;
      list.style.visibility = list.style.visibility === 'visible' ? 'hidden' : "visible";
      // list.style.display = list.style.display === 'none' ? 'block' : "none";

      list.classList.toggle('show-card');

      // this.classList.toggle('show-list-text');
    }
    toggleMap.addEventListener('click', mapToggleEvent);
  }
})();



const fetchRoute = (data, map) => {
     const apiKey = process.env['HERE_API_KEY']
  let routeEndpoint = `https://route.ls.hereapi.com/routing/7.2/calculateroute.json?waypoint0=${userAddress.join(',')}`;
  const waypoints = data.results[0].waypoints;
  for ( let i = 0; i < waypoints.length; i++) {
    routeEndpoint += `&waypoint${i+1}=${waypoints[i].lat},${waypoints[i].lng}`;
  }
  routeEndpoint += `&representation=display&mode=fastest;car&departure=now&apiKey=${apiKey}`;
  fetch(routeEndpoint)
  .then(response => response.json())
  .then((data) => {
    addRouteToMap(data, map);
    addDirectionsToMap(data, map);
  });
}

const fetchSequence = (map) => {
    const apiKey = process.env['HERE_API_KEY']
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

const createMapElement = (reduced, defaultLayers) => {
  if (document.getElementById('map')) {
    const map = new H.Map(document.getElementById('map'),
      reduced, {
      center: {lat: 52.51477270923461, lng: 13.39846691425174},
      zoom: 13,
      pixelRatio: window.devicePixelRatio || 1
    });
    const ui = H.ui.UI.createDefault(map, defaultLayers);

    var mapSettings = ui.getControl('mapsettings');
  var zoom = ui.getControl('zoom');
  // var scalebar = ui.getControl('scalebar');

    mapSettings.setAlignment('top-left');
    zoom.setAlignment('top-left');
    // scalebar.setAlignment('top-left');
    // map.setMapScheme("NMAMapSchemeReducedDay")
    H.map
    console.log(map)
    return map;
  }
};

const initMap = () => {
  const platform = new H.service.Platform({
    apikey: process.env['HERE_API_KEY']
  });
  const defaultLayers = platform.createDefaultLayers();
  const reduced = platform.getMapTileService({
    type: 'base'
  }).createTileLayer("maptile", "reduced.day", 256, "png8");
  const newMap = createMapElement(reduced, defaultLayers);
  fetchSequence(newMap);
  window.addEventListener('resize', () => newMap.getViewPort().resize());
  // Behavior implements default interactions for pan/zoom (also on mobile touch environments)
  const behavior = new H.mapevents.Behavior(new H.mapevents.MapEvents(newMap));
  // setInteractive(newMap);
}

export { initMap };


