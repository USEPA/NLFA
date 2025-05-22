var boolNewQuery;
var fLayerPoints, fLayerLines, fLayerPolygons;
var zoomExtent;
var advNumsSelected = [];
var numCompletes;
var newExtent;
var numWbPopUpCounter = 0;
var textWbShow = "";
var boolFedText=false;

function GetStateSelected(evt, st) {
    //If coming from the clickable map, then Get the state from the click
    if (st==='US') {            
        getStAbbrev(evt, clickMap, false); //getStAbbrev is in layout.js
    } else { 
        // if one of territories or AK/HI then know the state already    
        setHiddenStateVar(st);     
        //update the state dropdownlist
        var st = dojo.byId("ctl00_cpContent_pnlMap_StateSelected").value;
        if ((st != null) && (ddlState != null))
        {
            var states = ddlState.GetItemCount() - 1;
            for (var item = 0; item <= states; item++)
            {
                if (ddlState.GetItem(item) != null)
                {
                    var value = ddlState.GetItem(item).value;
                    if (value != "")
                    {
                        if (value.indexOf(st.toUpperCase() + "~") > -1)
                        {
                            ddlState.SetSelectedItem(ddlState.GetItem(item));
                        }
                    }
                }
            }
            ddlState_SelectedIndexChanged();
        }                          
    }
}

function setHiddenStateVar(st) {
    dojo.byId("ctl00_cpContent_pnlMap_StateSelected").value = st;
    getStateExtent(st,true,false);
}

function getStateExtent(st, boolZoom, boolTechQuery) {
    if (boolZoom) {
        esri.show(dojo.byId("mapStatus"));
    }
    
    //resetMapItems();
    
    //Need to query the state layer for the start extent
    var stQueryTask = new esri.tasks.QueryTask("https://" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + advWhereULiveMSName + "/MapServer/0");
    
    //build query filter
    var queryGeom = new esri.tasks.Query();
    queryGeom.outSpatialReference = {"wkid":102100};
    queryGeom.returnGeometry = true;    
    
    if (st != "") {
        //only change layer definitions for the general site.
        if (boolGeneralSite) {
            //Update the layer definition of the statewide/regional layers
            var layerDefinitions = [];
            layerDefinitions[0] = "ST='" + st + "'";
            layerDefinitions[1] = "ST='" + st + "'";
            layerDefinitions[2] = "ST='" + st + "'";
            statewideRegionalLayer.setLayerDefinitions(layerDefinitions);
            statewideBorder.setLayerDefinitions(layerDefinitions);   
     
            //Update the layer definition of the fish SDE layers
            if (boolFishLoaded) {
                var layerDefinitions2 = [];
                layerDefinitions2[1] = stFieldName + "='" + st + "'";
                layerDefinitions2[2] = stFieldName + "='" + st + "'";
                layerDefinitions2[3] = stFieldName + "='" + st + "'";
                layerDefinitions2[4] = stFieldName + "='" + st + "'";
                layerDefinitions2[5] = stFieldName + "='" + st + "'";
                layerDefinitions2[6] = stFieldName + "='" + st + "'";
                FishGen.setLayerDefinitions(layerDefinitions2); 
            }     
        }
        switch (st){
            case "AK": 
                if (boolZoom) {
                    map.setExtent(AKExtent);
                }
                stateExtent=AKExtent;
                break;
            case "HI":
                 if (boolZoom) {
                    map.setExtent(HIExtent);
                }
                stateExtent=HIExtent; 
                break;               
            case "PR":
                if (boolZoom) {
                    map.setExtent(PRExtent);
                }
                stateExtent=PRExtent;
                break;
            case "VI":
                if (boolZoom) {
                    map.setExtent(VIExtent);
                }
                stateExtent=VIExtent;
                break;
            case "GUAM": 
                if (boolZoom) {
                    map.setExtent(GuamExtent);
                }
                stateExtent=GuamExtent;
                break;
            case "GU": 
                if (boolZoom) {
                    map.setExtent(GuamExtent);
                }
                stateExtent=GuamExtent;
                break;
            case "AS":
                if (boolZoom) {
                    map.setExtent(ASExtent);
                }
                stateExtent=ASExtent;
                break;
            case "MS":
                if (boolZoom) {
                    map.setExtent(MSExtent);
                }
                stateExtent=MSExtent;
                break;
                
            case "AR":
                if (boolZoom) {
                    map.setExtent(ARExtent);
                }
                stateExtent=ARExtent;
                break;
            case "MD":
                if (boolZoom) {
                    map.setExtent(MDExtent);
                }
                stateExtent=MDExtent;
                break;
            case "AZ":
                if (boolZoom) {
                    map.setExtent(AZExtent);
                }
                stateExtent=AZExtent;
                break;
            case "NH":
                if (boolZoom) {
                    map.setExtent(NHExtent);
                }
                stateExtent=NHExtent;
                break;
            case "PA":
                if (boolZoom) {
                    map.setExtent(PAExtent);
                }
                stateExtent=PAExtent;
                break;
            case "SC":
                if (boolZoom) {
                    map.setExtent(SCExtent);
                }
                stateExtent=SCExtent;
                break;
            case "SD":
                if (boolZoom) {
                    map.setExtent(SDExtent);
                }
                stateExtent=SDExtent;
                break;
            case "TN":
                if (boolZoom) {
                    map.setExtent(TNExtent);
                }
                stateExtent=TNExtent;
                break;           
            case "WA":
                if (boolZoom) {
                    map.setExtent(WAExtent);
                }
                stateExtent=WAExtent;
                break; 
            case "VT":
                if (boolZoom) {
                    map.setExtent(VTExtent);
                }
                stateExtent=VTExtent;
                break;                             
            case "NY":
                if (boolZoom) {
                    map.setExtent(NYExtent);
                }
                stateExtent=NYExtent;
                break;
            case "CT":
                if (boolZoom) {
                    map.setExtent(CTExtent);
                }
                stateExtent=CTExtent;
                break;
            case "NV":
                if (boolZoom) {
                    map.setExtent(NVExtent);
                }
                stateExtent=NVExtent;
                break;             
            case "NJ":
                if (boolZoom) {
                    map.setExtent(NJExtent);
                }
                stateExtent=NJExtent;
                break;
            case "UT":
                if (boolZoom) {
                    map.setExtent(UTExtent);
                }
                stateExtent=UTExtent;
                break;                
            case "MA":
                if (boolZoom) {
                    map.setExtent(MAExtent);
                }
                stateExtent=MAExtent;
                break;                
            case "NE":
                if (boolZoom) {
                    map.setExtent(NEExtent);
                }
                stateExtent=NEExtent;
                break;
            case "DE":
                if (boolZoom) {
                    map.setExtent(DEExtent);
                }
                stateExtent=DEExtent;
                break;
            case "DC":
                if (boolZoom) {
                    map.setExtent(DCExtent);
                }
                stateExtent=DCExtent;
                break;           
            case "VA":
                if (boolZoom) {
                    map.setExtent(VAExtent);
                }
                stateExtent=VAExtent;
                break;
            case "RI":
                if (boolZoom) {
                    map.setExtent(RIExtent);
                }
                stateExtent=RIExtent;
                break;
            case "NM":
                if (boolZoom) {
                    map.setExtent(NMExtent);
                }
                stateExtent=NMExtent;
                break;
            case "OR":
                if (boolZoom) {
                    map.setExtent(ORExtent);
                }
                stateExtent=ORExtent;
                break;
            case "OK":
                if (boolZoom) {
                    map.setExtent(OKExtent);
                }
                stateExtent=OKExtent;
                break; 
            case "ND":
                if (boolZoom) {
                    map.setExtent(NDExtent);
                }
                stateExtent=NDExtent;
                break;  
            case "CA":
                if (boolZoom) {
                    map.setExtent(CAExtent);
                }
                stateExtent=CAExtent;
                break;                
            case "WY":
                if (boolZoom) {
                    map.setExtent(WYExtent);
                }
                stateExtent=WYExtent;
                break;                
            case "MT":
                if (boolZoom) {
                    map.setExtent(MTExtent);
                }
                stateExtent=MTExtent;
                break; 
            case "ME":
                if (boolZoom) {
                    map.setExtent(MEExtent);
                }
                stateExtent=MEExtent;
                break;                
            case "TX":
                if (boolZoom) {
                    map.setExtent(TXExtent);
                }
                stateExtent=TXExtent;
                break;               
            case "AL":
                if (boolZoom) {
                    map.setExtent(ALExtent);
                }
                stateExtent=ALExtent;
                break;               
            case "IN":
                if (boolZoom) {
                    map.setExtent(INExtent);
                }
                stateExtent=INExtent;
                break;  
            case "FL":
                if (boolZoom) {
                    map.setExtent(FLExtent);
                }
                stateExtent=FLExtent;
                break; 
            case "ID":
                if (boolZoom) {
                    map.setExtent(IDExtent);
                }
                stateExtent=IDExtent;
                break;              
            case "GA":
                if (boolZoom) {
                    map.setExtent(GAExtent);
                }
                stateExtent=GAExtent;
                break;     
            case "IA":
                if (boolZoom) {
                    map.setExtent(IAExtent);
                }
                stateExtent=IAExtent;
                break;                
            case "KS":
                if (boolZoom) {
                    map.setExtent(KSExtent);
                }
                stateExtent=KSExtent;
                break; 
            case "KY":
                if (boolZoom) {
                    map.setExtent(KYExtent);
                }
                stateExtent=KYExtent;
                break;                
            case "LA":
                if (boolZoom) {
                    map.setExtent(LAExtent);
                }
                stateExtent=LAExtent;
                break;               
            case "MO":
                if (boolZoom) {
                    map.setExtent(MOExtent);
                }
                stateExtent=MOExtent;
                break; 
            case "MI":
                if (boolZoom) {
                    map.setExtent(MIExtent);
                }
                stateExtent=MIExtent;
                break;                
            case "NC":
                if (boolZoom) {
                    map.setExtent(NCExtent);
                }
                stateExtent=NCExtent;
                break;                
            case "OH":
                if (boolZoom) {
                    map.setExtent(OHExtent);
                }
                stateExtent=OHExtent;
                break;                
            case "WI":
                if (boolZoom) {
                    map.setExtent(WIExtent);
                }
                stateExtent=WIExtent;
                break;   
            case "WV":
                if (boolZoom) {
                    map.setExtent(WVExtent);
                }
                stateExtent=WVExtent;
                break;                 
            case "CO":
                if (boolZoom) {
                    map.setExtent(COExtent);
                }
                stateExtent=COExtent;
                break;                
            case "IL":
                if (boolZoom) {
                    map.setExtent(ILExtent);
                }
                stateExtent=ILExtent;
                break; 
            case "MN":
                if (boolZoom) {
                    map.setExtent(MNExtent);
                }
                stateExtent=MNExtent;
                break;                                                                                                                                                
            case "US":
                stateExtent=selectExtent; 
                if (boolZoom) {
                    map.setExtent(initExtent); //zoom to US (initExtent) not selectExtent b/c selectExtent is much bigger
                } 
                break;
            default:
                if (boolZoom){ 
                    map.setExtent(initExtent); 
                } 
                stateExtent=selectExtent;
                arcgisErrorHandler("No state extent found.");
                break;            
        }
        if (boolTechQuery) {
            var strMagicNumber = "";
            strMagicNumber = dojo.byId("ctl00_cpContent_pcResults_hfMagicNumber").value;
            
            //Setup the query to get the comids
            var queryGeom = new esri.tasks.Query();
            queryGeom.outSpatialReference = { "wkid": 102100 };
            queryGeom.returnGeometry = false; 
            //queryGeom.outFields = ["COMID"]; 
            queryGeom.where="SESSION_ID='" + strMagicNumber + "'";             
            
            queryGeom.outFields = ["ADVNUM"];
            
            if (strFishTechOrTissue==="TISSUE"){
                var strQueryLayer = "https://" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + fishTissueMSName + "/MapServer/";
                var MagicNumberQueryTask = new esri.tasks.QueryTask(strQueryLayer +numTissueWebSessionResultLayer);
            }else {
                var strQueryLayer = "https://" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + fishTechMSName + "/MapServer/";
                var MagicNumberQueryTask = new esri.tasks.QueryTask(strQueryLayer +numTechWebSessionResultLayer);
            }
            
                           
            MagicNumberQueryTask.execute(queryGeom,function(results) {
                if (boolQueryLimitHit) {
                
                    map.setExtent(stateExtent);
                    map.graphics.clear();
                    fLayerLines.hide();
                    fLayerPoints.hide();
                    fLayerPolygons.hide();
                    //Hide the loading image
                    esri.hide(dojo.byId("mapStatus"));
                }else {
                    if (results.features.length>=1000) {
                        //alert("Your search has produced too much data to display on the map. Please refine your search options or view your current search results in the report tab.");
                        alert(txtMapTooMuchData);
                        boolQueryLimitHit=true;  
                        if (ddlState.GetText() == 'All') { //If the user did not choose a state then do not change extent
                        }else {         //if user chose a state then zoom to that state               
                            map.setExtent(stateExtent);
                        }
                        map.graphics.clear();
                        fLayerLines.hide();
                        fLayerPoints.hide();
                        fLayerPolygons.hide();
                        //Hide the loading image
                        esri.hide(dojo.byId("mapStatus"));
                    }else {
                        
                        var listAdvNums="";
                        for (var j=0; j<results.features.length; j++) {
                            
                            if (listAdvNums.indexOf("'" + results.features[j].attributes["ADVNUM"].replace("'","''") + "'") === -1) {
                                if (listAdvNums != "" ) {
                                    listAdvNums = listAdvNums + ",";
                                }
                                listAdvNums=listAdvNums + "'" + results.features[j].attributes["ADVNUM"].replace("'","''") + "'";
                            }
                        }
                        if (results.features.length > 0) {
                            doTechnicalQuery_Complete(listAdvNums);
                        }else {
                            numCompletes = numCompletes + 1;
                        } 
                    }                       
                }
            },function(error) { arcgisErrorHandler(error);});

            

        }
       
//        if (st==="AK") {
//            if (boolZoom) {
//                map.setExtent(AKExtent);
//            }
//            stateExtent=AKExtent;
//            if (boolTechQuery) {
//                doTechnicalQuery_Complete();
//            }
//        }else if (st==="HI") {
//            if (boolZoom) {
//                map.setExtent(HIExtent);
//            }
//            stateExtent=HIExtent;
//            if (boolTechQuery) {
//                doTechnicalQuery_Complete();
//            }
//        }else if (st==="PR") {
//            if (boolZoom) {
//                map.setExtent(PRExtent);
//            }
//            stateExtent=PRExtent;
//            if (boolTechQuery) {
//                doTechnicalQuery_Complete();
//            }
//        }else if (st==="VI") {
//            if (boolZoom) {
//                map.setExtent(VIExtent);
//            }
//            stateExtent=VIExtent;
//            if (boolTechQuery) {
//                doTechnicalQuery_Complete();
//            }
//        }else if ((st==="GUAM") || (st==="GU")) {
//            if (boolZoom) {
//                map.setExtent(GuamExtent);
//            }
//            stateExtent=GuamExtent;
//            if (boolTechQuery) {
//                doTechnicalQuery_Complete();
//            }
//        }else if (st==="AS") {
//            if (boolZoom) {
//                map.setExtent(ASExtent);
//            }
//            stateExtent=ASExtent;
//            if (boolTechQuery) {
//                doTechnicalQuery_Complete();
//            }
//        }else if (st==="US") {
//            stateExtent=selectExtent; 
//            if (boolZoom) {
//                map.setExtent(initExtent); //zoom to US (initExtent) not selectExtent b/c selectExtent is much bigger
//            }  
//            if (boolTechQuery) {
//                doTechnicalQuery_Complete();
//            }    
//        }else {
//            //Continental US - so need to determine extent from map service layer
//            queryGeom.where = "st='" + st + "'";
//            
//            //Execute task and zoom to state
//            //onError just use entire US
//            stQueryTask.execute(queryGeom, function(fset) {
//              if (fset.features.length !== 0) {
//                var startExtent=fset.features[0].geometry.getExtent(); 
//                stateExtent=startExtent.expand(1.4);
//                if (boolTechQuery) {
//                    doTechnicalQuery_Complete();
//                }
//                //map.setExtent(startExtent.expand(1.4)); 
//                if (boolZoom) {                    
//                    map.setExtent(stateExtent);
//                    esri.hide(dojo.byId("mapStatus"));  
//                }                            
//              } 
//            }, function(error) { if(boolZoom){ map.setExtent(initExtent); } stateExtent=selectExtent; arcgisErrorHandler(error);} );
//        }


        if (boolZoom) {
            esri.hide(dojo.byId("mapStatus"));
        }
        
    }        
}


function addSelectionFeatureLayers(mapServiceName)
{    
    
    //Use the FISH_TECH (for technical site) or FISH_POP (for general site) layer as the zoom layer
    var queryLayer = "https://" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + mapServiceName + "/MapServer";
    //if (mapServiceName===fishTissueMSName) {
        var arrayQueryIDs=[8,9,10];
    //}else {
//    if (mapServiceName === fishTechMSName) {
//        var arrayQueryIDs=[1,2,3,4,5,6];  
//    }
    //This function is used for technical query and general site
    //if general site then do popup, if tech site then no popup
    var boolPopUp=false;
    if ((mapServiceName===fishTechMSName) || (mapServiceName===fishTissueMSName)) {
        boolPopUp=false;
    } else if (mapServiceName===fishGenMSName) {
        boolPopUp=true;
    }    
   
   //loop through each layer (point, line, polygon) to add feature geom to map
    for (var i=0; i<arrayQueryIDs.length; i++) {        
                        
        //set symbol
        //if (fLayer.graphics.geometry.type.toString().search("point") != -1) {
        //if ((arrayQueryIDs[i] === 1) || (arrayQueryIDs[i] === 4))  {
        if ((arrayQueryIDs[i] === 8))  {
            //var symbol = new esri.symbol.SimpleMarkerSymbol(esri.symbol.SimpleMarkerSymbol.STYLE_CIRCLE, 10, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([0,0,0]), 1), new dojo.Color([0,255,255]));
            var symbol = new esri.symbol.SimpleMarkerSymbol().setSize(10).setOutline(new esri.symbol.SimpleLineSymbol().setColor(new dojo.Color([0,0,0])).setWidth(1)).setColor(new dojo.Color([0,255,255]));
            //Create the feature layer and add it to the map.  Need Feature Layer to do selection.
            fLayerPoints = new esri.layers.FeatureLayer(queryLayer + "/" + arrayQueryIDs[i], {mode: esri.layers.FeatureLayer.MODE_SELECTION, outFields: ["*"]});
            fLayerPoints.setSelectionSymbol(symbol);
            map.addLayer(fLayerPoints);

        //}else if (fLayer.geometryType.toString().search("line") != -1) {
        //}else if ((arrayQueryIDs[i] === 2) || (arrayQueryIDs[i] === 5)) {
        }else if ((arrayQueryIDs[i] === 9)) {
            //var symbol = new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([0,255,255]), 3);
            var symbol = new esri.symbol.SimpleLineSymbol().setColor(new dojo.Color([0,255,255])).setWidth(3);
            fLayerLines = new esri.layers.FeatureLayer(queryLayer + "/" + arrayQueryIDs[i], {mode: esri.layers.FeatureLayer.MODE_SELECTION, outFields: ["*"]});
            fLayerLines.setSelectionSymbol(symbol);
            map.addLayer(fLayerLines);
        //}else if (fLayer.geometryType.toString().search("Polygon") != -1) {
        //}else if ((arrayQueryIDs[i] === 3) || (arrayQueryIDs[i] === 6)) {
        }else if ((arrayQueryIDs[i] === 10)) {
            //var symbol = new esri.symbol.SimpleFillSymbol(esri.symbol.SimpleFillSymbol.STYLE_SOLID, new esri.symbol.SimpleLineSymbol(esri.symbol.SimpleLineSymbol.STYLE_SOLID, new dojo.Color([0,255,255]), 2), new dojo.Color([0,255,255,0.8]));
            var symbol = new esri.symbol.SimpleFillSymbol().setOutline(new esri.symbol.SimpleLineSymbol().setColor(new dojo.Color([0,255,255])).setWidth(2)).setColor(new dojo.Color([0,255,255,0.8]));
            
            fLayerPolygons = new esri.layers.FeatureLayer(queryLayer + "/" + arrayQueryIDs[i], {mode: esri.layers.FeatureLayer.MODE_SELECTION, outFields: ["*"]});
            fLayerPolygons.setSelectionSymbol(symbol);
            map.addLayer(fLayerPolygons);
        }               
                
    }

    dojo.connect(fLayerPoints, "onSelectionComplete", function()
    {
        //alert(fLayerPoints.getSelectedFeatures().length);        
        //fLayerPolygons.selectFeatures(queryGeom,esri.layers.FeatureLayer.SELECTION_NEW,null,function(error){alert("Technical Query Map error (polygons). " + error);});
        if (boolQueryLimitHit === false){        
            completeSelectionAndZoom(fLayerPoints, boolPopUp);   
        }           
    });

    dojo.connect(fLayerPolygons, "onSelectionComplete", function()
    {
        //alert(fLayerPolygons.getSelectedFeatures().length); 
        //fLayerLines.selectFeatures(queryGeom,esri.layers.FeatureLayer.SELECTION_NEW,null,function(error){alert("Technical Query Map error (lines). " + error);});
        if (boolQueryLimitHit === false){
            completeSelectionAndZoom(fLayerPolygons, boolPopUp);  
        }               
    });

    dojo.connect(fLayerLines, "onSelectionComplete", function()
    {
        //alert(fLayerLines.getSelectedFeatures().length); 
        if (boolQueryLimitHit === false){
            completeSelectionAndZoom(fLayerLines, boolPopUp);           
        }      
     });
     
//     dojo.connect(fLayerPoints, "onSelectionClear",function(){ completeSelectionAndZoom(fLayerPoints, true);});
//     dojo.connect(fLayerPolygons, "onSelectionClear",function(){ completeSelectionAndZoom(fLayerPolygons, true);});
//     dojo.connect(fLayerLines, "onSelectionClear",function(){ completeSelectionAndZoom(fLayerLines, true);});

          
}

function completeSelectionAndZoom(fLayer, boolPopUp){
    //Do not run this code if the user clicked the AdvNum/station b/c want to zoom there.
    if (boolAdvNumClickFromReport===false) {
        //Keep a counter of how many times have come to this function for this query
        //b/c this function is called on complete of points, lines, polygons selection.
        //Once all 3 are done then can actually zoom and show popup if needed.
        numCompletes = numCompletes + 1;
        
        //Every time we want to update the extent box - but we dont zoom to it yet
        updateZoomExtentForQuery(fLayer, boolPopUp);
        
        if (boolQueryLimitHit) {
            map.setExtent(stateExtent);
            map.graphics.clear();
            fLayerLines.hide();
            fLayerPoints.hide();
            fLayerPolygons.hide();
            //Hide the loading image
            esri.hide(dojo.byId("mapStatus"));   
        }else{
            //We have completed selection on all 3 layers now so now we can really do something
            if (numCompletes===3) {
                //boolPop is only true for the general site b/c it has the popup for the waterbody query      
                if (boolPopUp) {
                    //For the general site, if we have looked in all 3 layers and we still have no advisories 
                    //selected then let's set the zoom extent to the extent of the waterbody from the nameService
                    if (advNumsSelected.length === 0){
                        var strMinx=dojo.byId("ctl00_cpContent_pnlMap_WaterbodyMinX").value;
                        var strMiny=dojo.byId("ctl00_cpContent_pnlMap_WaterbodyMinY").value;
                        var strMaxx=dojo.byId("ctl00_cpContent_pnlMap_WaterbodyMaxX").value;
                        var strMaxy=dojo.byId("ctl00_cpContent_pnlMap_WaterbodyMaxY").value;
                        if ((strMaxx!=null) && (strMaxx!="")) {
                            //If we have a box then just project it
                            var nameServiceExtent=new esri.geometry.Extent(strMinx,strMiny,strMaxx,strMaxy, new esri.SpatialReference({ wkid:4269 }));                    
                            zoomExtent=esri.geometry.geographicToWebMercator(nameServiceExtent);                                 
                        }else {                    
                            //If we have only a point then we have to project that and make it an extent
                            var nameServicePoint = new esri.geometry.Point(strMinx,strMiny, new esri.SpatialReference({ wkid:4269 })); 
                            var zoomPoint=esri.geometry.geographicToWebMercator(nameServicePoint); 
                            zoomExtent=zoomPoint.geometry.getExtent();
                        }                
                    }
                               
                    //change the extent here         
                    map.setExtent(zoomExtent.expand(1.4));
                 
                }else {            
                    //For all sites except the general site
                    //change the extent here  
                    
                    //For the technical and fish tissue sites, if we have looked in all 3 layers and we still have no advisories 
                    //selected then let's set the zoom extent to the extent of the State (if one is selected) - otherwise back to initExtent
                    if ((fLayerPoints.getSelectedFeatures().length === 0) && (fLayerLines.getSelectedFeatures().length === 0) && (fLayerPolygons.getSelectedFeatures().length === 0)){
                        //Zoom to state extent
                        var st = ddlState.GetSelectedItem().value;
                        if ((st!=null) && (st!="")) {
                            getStateExtent(st,true,false);
                        }else {
                            //change the extent here       
                            map.setExtent(zoomExtent.expand(1.4));
                        }
                        //Show popup that no advisories/stations were selected in the query
                        var strType="advisory";
                        if (fLayer.name.indexOf("Tissue") != -1) {
                            strType="station";
                        }
                        showNoQueryResultsFoundPopUp(strType);    
                    }else {
                    
                        //change the extent here       
                        map.setExtent(zoomExtent.expand(1.4));
                    }             
                }
            
                //Show popup if on general site
                if (boolPopUp) {
                    //Popup the info about the advisory or at least the national advisory
                    waterbodyTablePopUp();     
                }else {
                    //For tech/tissue be sure to show the selection layers now
                    fLayerPoints.show();
                    fLayerLines.show();
                    fLayerPolygons.show();
                }
                
                //Hide the loading image
                esri.hide(dojo.byId("mapStatus"));
            }
            
        } //if boolQueryLimitHit
        
        
    }
}

function selectWaterbody() {
    //alert("Select Waterbody Test!");    
    
    //Popup text so user knows selection may take a long time.
    esri.show(dojo.byId("mapStatus"));
    
    map.infoWindow.hide();
    esri.hide(dojo.byId("waterbodyPopUpDiv"));          
            
    //Start of new query
    boolNewQuery=true;
    advNumsSelected=[];
    numCompletes=0; 
    
    //Load the fish sde layers b/c they are not loaded until the 1st time user
    //selects a waterbody then once the fish layers are loaded we can call selectWaterbody again
    if (boolFishLoaded===false){
        loadFishLayers(); 
    }else {
    
        //Make sure the featureLayers are there - if not add them
        if ((fLayerPoints===null) || (fLayerLines === null) || (fLayerPolygons===null) || (fLayerPoints===undefined) || (fLayerLines === undefined) || (fLayerPolygons===undefined)) {
            addSelectionFeatureLayers(fishGenMSName);
        }
        //Make sure selection Layers are turned on.
        inputs = dojo.query(".selection_list");
        dojo.forEach(inputs,function(input){
            input.checked=true;
        });
        fLayerPoints.show();
        fLayerLines.show();
        fLayerPolygons.show();
        
        //query for points,lines,polygons from identifylayer
        var strWbName = "";
        strWbName = dojo.byId("ctl00_cpContent_pnlMap_WaterbodySelected").value;
        
        var strSt = "";
        strSt = dojo.byId("ctl00_cpContent_pnlMap_StateSelected").value;
        
        //Setup the query to get the comids
        var queryGeom = new esri.tasks.Query();
        queryGeom.outSpatialReference = { "wkid": 102100 };
        queryGeom.returnGeometry = false; 

        queryGeom.where="GNIS_NAME=UPPER('" + strWbName.replace("'","''") + "') and STATE='" + strSt + "'";             

        var arrayQueryIDs=[numWaterbodiesLayer];
        var strQueryLayer = "https://" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + fishGenMSName + "/MapServer/";

        //loop through each layer (point, line, polygon) 
        for (var i=0; i<arrayQueryIDs.length; i++) { 

            queryGeom.outFields = ["ADVNUM"];
            var MagicNumberQueryTask = new esri.tasks.QueryTask(strQueryLayer + arrayQueryIDs[i]);
            
            MagicNumberQueryTask.execute(queryGeom,function(results) {
                if (boolQueryLimitHit) {
                
                    map.setExtent(stateExtent);
                    map.graphics.clear();
                    fLayerLines.hide();
                    fLayerPoints.hide();
                    fLayerPolygons.hide();
                    //Hide the loading image
                    esri.hide(dojo.byId("mapStatus"));
                }else {
                    if (results.features.length>=1000) {
                        //alert("Your search has produced too much data to display on the map. Please refine your search options or view your current search results in the report tab.");
                        alert(txtMapTooMuchData);
                        boolQueryLimitHit=true;                            
                        map.setExtent(stateExtent);
                        map.graphics.clear();
                        fLayerLines.hide();
                        fLayerPoints.hide();
                        fLayerPolygons.hide();
                        //Hide the loading image
                        esri.hide(dojo.byId("mapStatus"));
                    }else {
                        
                        var listAdvNums="";                        
                        for (var j=0; j<results.features.length; j++) {
                            
                            if (listAdvNums.indexOf("'" + results.features[j].attributes["ADVNUM"].replace("'","''") + "'") === -1) {
                                if (listAdvNums != "" ) {
                                    listAdvNums = listAdvNums + ",";
                                }
                                listAdvNums=listAdvNums + "'" + results.features[j].attributes["ADVNUM"].replace("'","''") + "'";
                                //advNumsSelected.push(results.features[j].attributes["ADVNUM"]);
                                boolFound=false;        
                                for (j=0; j<advNumsSelected.length; j++){
                                    if (advNumsSelected[j]===results.features[j].attributes["ADVNUM"].replace("'","''")){
                                        boolFound=true;
                                        break;
                                    }            
                                }
                                if (boolFound === false) {
                                    advNumsSelected.push(results.features[j].attributes["ADVNUM"].replace("'","''"));
                                }
                            }
                        }

                        selectWaterbody_Complete(listAdvNums);

                    }  //end if (results.features.length>=1000                     
                } //end if (boolQueryLimitHit) {
            }, function(error) { arcgisErrorHandler(error);});
            
        } //end for (var i=0;
    } // end if (boolFishLoaded===false){
} //end function
 
function selectWaterbody_Complete(listAdvNums){        
                    
    //query for points,lines,polygons from identifylayer
    var strWbName = "";
    strWbName = dojo.byId("ctl00_cpContent_pnlMap_WaterbodySelected").value;
    
    var strSt = "";
    strSt = dojo.byId("ctl00_cpContent_pnlMap_StateSelected").value;
    //var ncExtent = new esri.geometry.Extent({"xmin":-9554000 ,"ymin": 3941000 ,"xmax":-8190000 ,"ymax":4485000,"spatialReference":{"wkid":102100}});
    
    if (listAdvNums===""){
        listAdvNums="''";
    }
    if (listAdvNums != null) {
        //Setup the query for the selection"reachcode in (select reachcode from rad_nhd.nhdflowline_sde where UPPER(gnis_name) = 'NEUSE RIVER') and SOURCE_ORIGINATOR = 'NC'"
        var queryGeom = new esri.tasks.Query();
        queryGeom.outSpatialReference = { "wkid": 102100 };
        queryGeom.returnGeometry = false;
        queryGeom.geometry = stateExtent; //initExtent; //ncExtent;
       
       // var strQuery="COMID in (select COMID from RAD_FISH_LW_SDE_V where GNIS_NAME = upper('" + strWbName + "') and STATE = '" + strSt + "')";
       var strQuery="SOURCE_FEATUREID IN (" + listAdvNums + ")";  
       
        queryGeom.where=strQuery;
        
    //        queryGeom.where=strQueryPoints;
        fLayerPoints.selectFeatures(queryGeom, esri.layers.FeatureLayer.SELECTION_NEW, null, function(error) { arcgisErrorHandler(error); });
        
    //        queryGeom.where=strQueryPolygons;
        fLayerPolygons.selectFeatures(queryGeom, esri.layers.FeatureLayer.SELECTION_NEW, null, function(error) { arcgisErrorHandler(error); });
        
    //        queryGeom.where=strQueryLines;
        fLayerLines.selectFeatures(queryGeom, esri.layers.FeatureLayer.SELECTION_NEW, null, function(error) { arcgisErrorHandler(error); });        
    } else {
        arcgisErrorHandler("No AdvNums found.");        
    }    
}

function waterbodyTablePopUp() {    
    //If we have an advisory number to query on then show the advisory info
    var st = dojo.byId("ctl00_cpContent_pnlMap_StateSelected").value;
    if (advNumsSelected.length === 0 ) {
        //If we have no advisory number then just show federal advisory info
        showFederalAdvisoryPopUp();
        //get the statewides/regionals        
        getStatewides(st);
    }else {
        identifyQuery.where = "Advisory_Number in(" + advNumsSelected.toString() + ")";
        queryTask.execute(identifyQuery, function(results) { showResults(results, null); getStatewides(st); }, function(error) { arcgisErrorHandler(error);});
    }

    advNumsSelected=[];        
}

//function getWbPopUpClose(){
//    var strCloseText="";
//    strCloseText="<span style='text-align:right;' onClick='esri.hide(dojo.byId(&quot;waterbodyPopUpDiv&quot;));'>Close</span>";
//    dijit.byId("wbClose").setContent(strCloseText);
//}

//This function queries the statewide/regional layers to determine if any to show in results
//This is used for waterbody query results
function getStatewides(st){
    //var st = dojo.byId("ctl00_cpContent_pnlMap_StateSelected").value;
    var statewideQuery = new esri.tasks.Query();
    statewideQuery.returnGeometry = false;
    statewideQuery.outFields = ['*'];    
    statewideQuery.where = "ST='" + st + "'";
    
    boolFedText=false;
    
    //Query Regional Layer
    var statewideQueryTask = new esri.tasks.QueryTask("https://" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + stateRegionalActiveMSName + "/MapServer/0");
    statewideQueryTask.execute(statewideQuery, function(results) { showStatewideResults(results, null); }, function(error) { arcgisErrorHandler(error);});
    
    statewideQuery.where = "ST='" + st + "'";
    //Query Statewide layer
    statewideQueryTask = new esri.tasks.QueryTask("https://" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + stateRegionalActiveMSName + "/MapServer/1");
    statewideQueryTask.execute(statewideQuery, function(results) { showStatewideResults(results, null); },function(error) { arcgisErrorHandler(error);});

}

function showWaterbodyPopUp(title,text){
    //This function shows the waterbody popup.  We get data from both the advisory layers and the statewide/regional layers
    //so don't want to show popup until have both sets of info.
    numWbPopUpCounter = numWbPopUpCounter + 1;
    if ((textWbShow == "") && (text != ""))
    {
        textWbShow = text;
    }
    else {
        textWbShow = textWbShow + text;
    }
    
//    if ((textWbShow != "") && (text != "")) 
//    {
//        if (numWbPopUpCounter===2) {
//            textWbShow = textWbShow + "<hr class='divider' />" + text;
//        }else {
//            textWbShow = textWbShow + text;
//        }
//    }
    if (numWbPopUpCounter===3){
        dijit.byId("wbTitle").setContent(title);
        dijit.byId("wbContent").setContent(textWbShow);
        esri.show(dojo.byId("waterbodyPopUpDiv")); 
        //reset global vars 
        numWbPopUpCounter=0;
        textWbShow = "";
        boolFedText=false;
        //Hide loading message
        esri.hide(dojo.byId("mapStatus"));
    }  
}

function showFederalAdvisoryPopUp() {
    var strSt = "";
    strSt = dojo.byId("ctl00_cpContent_pnlMap_StateSelected").value;
    var strWb = "";
    strWb = dojo.byId("ctl00_cpContent_pnlMap_WaterbodySelected").value;
    identifyQuery.where = "STATE_ABBR = '" + strSt + "'";
    queryTask.execute(identifyQuery, function(res)
    {
        //getWbPopUpClose();
        var stateName = ddlState.GetSelectedItem().text;
        if (res.features.length===0) {
            var s = "<p>No state fish advisories were found for " + strWb + " in " + stateName + ".  Please refer to the <a target='newFishWin' href='NoStateSite.aspx?st=" + stateName + "'>" + stateName + " website</a> for more information on state advisories in " + stateName + ".</p>";
        }else{
        
            if (res.features[0].attributes["URL"] == null)
            {
                var s = "<p>No state fish advisories were found for " + strWb + " in " + stateName + ".  Please refer to the <a target='newFishWin' href='NoStateSite.aspx?st=" + stateName + "'>" + stateName + " website</a> for more information on state advisories in " + stateName + ".</p>";
            }
            else
            {
                var s = "<p>No state fish advisories were found for " + strWb + " in " + stateName + ".  Please refer to the <a target='newFishWin' href='" + res.features[0].attributes["URL"] + "'>" + stateName + " website</a> for more information on state advisories in " + stateName + ".</p>";
            }
        }
        showWaterbodyPopUp("Fish Advisory Information", s);
    }, function(error) { arcgisErrorHandler(error); });
}

function showNoQueryResultsFoundPopUp(strType) {
    var s = "<p>No locational information is available for this " + strType + ", and therefore it cannot be displayed on the map. Please select the report tab to view information about this " + strType + ".</p>";
    dijit.byId("wbTitle").setContent("No Locational Information Available");
    dijit.byId("wbContent").setContent(s);
    esri.show(dojo.byId("waterbodyPopUpDiv"));
}

function updateZoomExtentForQuery(fLayer, boolPopUp)
{
     //loop through the feature set.
    var fSelFeatures = fLayer.getSelectedFeatures();
    
    //With a GET we have a 1000 feature limit.
    if (fSelFeatures.length>=1000) {
        //alert("Your search has produced too much data to display on the map. Please refine your search options or view your current search results in the report tab.");
        alert(txtMapTooMuchData);
        boolQueryLimitHit=true;
    }else {
    
        var strSrcFeatIDField="";
        strSrcFeatIDField = "SOURCE_FEATUREID";
        
//        if (fLayer.geometryType==="esriGeometryPolyline"){
//            //strSrcFeatIDField = "RAD_NHD.RAD_FISH_L_SDE.SOURCE_FEATUREID";
//            strSrcFeatIDField = "source_featureid";
//        }else if ((fLayer.geometryType==="esriGeometryPoint") || (fLayer.geometryType==="esriGeometryMultipoint")) {
//        //}else if (fLayer.geometryType.toString().search("point") != -1) {
//            //strSrcFeatIDField = "RAD_NHD.RAD_FISH_P_SDE.SOURCE_FEATUREID";
//            strSrcFeatIDField = "source_featureid";
//        }else if (fLayer.geometryType==="esriGeometryPolygon"){
//            //strSrcFeatIDField = "RAD_NHD.RAD_FISH_A_SDE.SOURCE_FEATUREID";
//            strSrcFeatIDField = "source_featureid";
//        }
        
        for (var i=0; i<fSelFeatures.length; i++) {
            //boolPop is only true for the general site b/c it has the popup for the waterbody query      
//            if (boolPopUp) {
//                //Store the adv_num (source_featureID) so that can use this to show info in popup
//                //RAD_NHD.RAD_FISH_L_SDE.SOURCE_FEATUREID = "401495"
//                boolFound=false;        
//                for (j=0; j<advNumsSelected.length; j++){
//                    if (advNumsSelected[j]===fSelFeatures[i].attributes[strSrcFeatIDField]){
//                        boolFound=true;
//                        break;
//                    }            
//                }
//                if (boolFound === false) {
//                    advNumsSelected.push(fSelFeatures[i].attributes[strSrcFeatIDField]);
//                }
//            }
            
            if (fLayer.geometryType==="esriGeometryPoint") {
            //if (fLayer.geometryType.toString().search("point") != -1) {
                //unfortunately just doing an expand on the extent does not work b/c the extent is a point.  So we have to make it a box not a point.
                var geomExtent = new esri.geometry.Extent(fSelFeatures[i].geometry.x - 1,fSelFeatures[i].geometry.y - 1, fSelFeatures[i].geometry.x + 1,fSelFeatures[i].geometry.y + 1, new esri.SpatialReference({ wkid:102100 }))
                geomExtent=geomExtent.expand(1000);                               
            }else {
                var geomExtent=fSelFeatures[i].geometry.getExtent();
                //if we have a multipoint but there is only 1 point in it then we need to zoom back out a little
                if (fLayer.geometryType==="esriGeometryMultipoint" ) {
                    if (fSelFeatures.length===1) {
                        //unfortunately just doing an expand on the extent does not work b/c the extent is a point.  So we have to make it a box not a point.
                        geomExtent=geomExtent.update(geomExtent.xmin-1,geomExtent.ymin-1,geomExtent.xmax+1,geomExtent.ymax+1,new esri.SpatialReference({ wkid:102100 }));                        
                        geomExtent=geomExtent.expand(1000);
                    }
                }
            }
            //if (zoomExtent===initExtent) {
            if (boolNewQuery) {
                //Nothing to compare to yet so go ahead and set 
                //new zoom extent equal to the extent of the 1st feature             
                zoomExtent=geomExtent;   
            } else{
                //need to check if should change zoom extent or not
                //if feature is already in our zoomExent then we are good
                //otherwise we need to change our zoomExtent to include the feature
                if (zoomExtent.contains(geomExtent) === false ) {
                    zoomExtent = zoomExtent.union(geomExtent);
                }
            }
            
            //Have already started getting query results so set the boolean value accordingly.
            //it will get reset to true when the user makes another query.
            boolNewQuery=false; 
            
        }
    }
}  

function ZoomClickedAdvisory(fset){
//This function zooms to the clicked advisory/station when the user clicks an advnum/stationID from the Report
    if ((fset.features.length > 0) && (boolStatewideFound===false)){
        dojo.forEach(fset.features, function(feature) {
            if (fset.geometryType==="esriGeometryPoint" ) {  
                //unfortunately just doing an expand on the extent does not work b/c the extent is a point.  So we have to make it a box not a point.                 
                var geomExtent = new esri.geometry.Extent(feature.geometry.x - 1,feature.geometry.y - 1, feature.geometry.x + 1,feature.geometry.y + 1, new esri.SpatialReference({ wkid:102100 }))
                geomExtent=geomExtent.expand(1000);
            }else {
                var geomExtent=feature.geometry.getExtent();
                 //if we have a multipoint but there is only 1 point in it then we need to zoom back out a little
                if (fset.geometryType==="esriGeometryMultipoint" ) {
                    if (fset.features.length===1) {
                        //unfortunately just doing an expand on the extent does not work b/c the extent is a point.  So we have to make it a box not a point.
                        geomExtent=geomExtent.update(geomExtent.xmin-1,geomExtent.ymin-1,geomExtent.xmax+1,geomExtent.ymax+1,new esri.SpatialReference({ wkid:102100 }));                        
                        geomExtent=geomExtent.expand(1000);
                    }
                }
            }
            //if (zoomExtent===initExtent) {
            if ((newExtent===undefined) || (newExtent===null)) {
                //Nothing to compare to yet so go ahead and set 
                //new zoom extent equal to the extent of the 1st feature             
                newExtent=geomExtent;   
            }else{
                //need to check if should change zoom extent or not
                //if feature is already in our zoomExent then we are good
                //otherwise we need to change our zoomExtent to include the feature
                if (newExtent.contains(geomExtent) === false ) {
                    newExtent = newExtent.union(geomExtent);
                }
            }
            
            //Have already started getting query results so set the boolean value accordingly.
            //it will get reset to true when the user makes another query.
            boolStart=false; 
                        
         });
    }
    
    //If we've gone through all 3 SDE layers then we can zoom.
    if (boolIdentifyGeomCounter===3) {
        if (boolStatewideFound) {
            //Actually zoom to the state extent in the showResults function
        }else { 
            if ((newExtent!=undefined) && (newExtent!=null)) {       
                map.setExtent(newExtent.expand(1.4)); 
            }  else {
                //set it to the state extent if we have no advisory               
                getStateExtent(stateAdvNumClicked,true,false);
//                map.setExtent(stateExtent);                                               
            }
        }     
        newExtent=null;
        stateAdvNumClicked="";
    }
}
   