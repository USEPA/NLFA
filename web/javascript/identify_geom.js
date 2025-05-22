/*global dojo,doIdentify,esri,dijit,addToMap,layerTabContent,bldgResults,parcelResults,queryTask,query*/

//boolIdentifyGeomCounter is used in zoomTools.js - ZoomClickedAdvisory but set here.
var boolIdentifyGeomCounter;
var boolStart=true;

function executeQueryGeomTask(boolZoom) {    
    //Have to call another query b/c want to get all the geometries w/ the advnum
    // the user clicked on the map.  This could have points, lines and polys.
    
    map.graphics.clear();
    var fSet = null;
    
    //query for points,lines,polygons from identifylayer
    var strAdvNum="";
    strAdvNum=dojo.byId(strAdvNumHiddenVarName).value;
   
   boolIdentifyGeomCounter=0;
   //loop through each layer (point, line, polygon) to add feature geom to map
    for (var i=0; i<arrayIDs.length; i++) {        
        
        queryGeomTask = new esri.tasks.QueryTask(idLayer + "/" + arrayIDs[i]);
        
        //build query filter
        var queryGeom = new esri.tasks.Query();
        queryGeom.outSpatialReference = {"wkid":102100};
        queryGeom.returnGeometry = true;
        queryGeom.where = "SOURCE_FEATUREID='" + strAdvNum + "'";
        
        //Execute task and call showResults on completion
        queryGeomTask.execute(queryGeom, function(fset) {
          //Once go through all 3 layers then we can actually zoom (boolIdentifyGeomCounter is used in zoomTools.js - ZoomClickedAdvisory)
          boolIdentifyGeomCounter = boolIdentifyGeomCounter + 1 ;
            
          //if (fset.features.length !== 0) {
            showFeature(fset, boolZoom);                                
          //} 
        },function(error) { arcgisErrorHandler(error);});
      
     }
    
//    queryGeomTask.execute(queryGeom, function(fset) {
//      if (fset.features.length === 1) {
//        showFeature(fset.features[0],evt);        
//      } else if (fset.features.length !== 0) {
//        showFeatureSet(fset,evt);        
//      } else {
//        dijit.byId("idResults").setContent("No Results Found");
//        map.infoWindow.show(evt.screenPoint, map.getInfoWindowAnchor(evt.screenPoint));
//      }
//    });
    
    
}

function showFeature(fset,boolZoom) {            
    if (fset.features.length !== 0) {    
        dojo.forEach(fset.features, function(feature) {
              //set symbol
              if (fset.geometryType.toString().search("point") != -1) {
                  //var symbol = new esri.symbol.SimpleMarkerSymbol(esri.symbol.SimpleMarkerSymbol.STYLE_CIRCLE, 10, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([0,0,0]), 1), new dojo.Color([255,190,0]));
                  var symbol = new esri.symbol.SimpleMarkerSymbol().setSize(10).setOutline(new esri.symbol.SimpleLineSymbol().setColor(new dojo.Color([0,0,0])).setWidth(1)).setColor(new dojo.Color([255,190,0]));
              }else if (fset.geometryType.toString().search("line") != -1) {
                  //var symbol = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255,190,0]), 3);
                  var symbol = new esri.symbol.SimpleLineSymbol().setColor(new dojo.Color([255,190,0])).setWidth(3);
              }else if (fset.geometryType.toString().search("Polygon") != -1) {
                  //var symbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([255,190,0]), 2), new dojo.Color([255,190,0,0.8]));
                  var symbol = new esri.symbol.SimpleFillSymbol().setOutline(new esri.symbol.SimpleLineSymbol().setColor(new dojo.Color([255,190,0])).setWidth(2)).setColor(new dojo.Color([255,190,0,0.8]));
              }
              map.graphics.add(feature.setSymbol(symbol));
            });
    }
        
    //Zoom if boolean val says to zoom
    if (boolZoom) {        
        ZoomClickedAdvisory(fset);
    }
}

//function showFeatureSet(fset,evt) {
//    //remove all graphics on the maps graphics layer
//    map.graphics.clear();
//    var screenPoint = evt.screenPoint;

//    featureSet = fset;

//    var numFeatures = featureSet.features.length;

//    //QueryTask returns a featureSet.  Loop through features in the featureSet and add them to the infowindow.
//    var title = "You have selected " + numFeatures + " fields.";
//    var content = "Please select desired field from the list below.<br />";

//    for (var i=0; i<numFeatures; i++) {
//      var graphic = featureSet.features[i];
//      content = content + graphic.attributes.FIELD_NAME + " Field (<A href='#' onclick='showFeature(featureSet.features[" + i + "]);'>show</A>)<br/>";
//    }

//    map.infoWindow.setTitle(title);
//    map.infoWindow.setContent(content);
//    map.infoWindow.show(screenPoint,map.getInfoWindowAnchor(evt.screenPoint));
//}
