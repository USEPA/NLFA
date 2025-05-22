/*global dojo,dijit*/

//

var FishLayer;


//Updates the layer visiblity for Technical and Tissue sites
function updateTechMapLayerVisibility(){
    updateSingleLayerVisiblity(".fish_list",FishLayer)      
}


//**********************************************************************************************************************
function buildTechMapLayerList(layer){ 
/*
**********************************************************************************************************************
Builds the layer list shown on the sidebar for the Techincal and Tissue sites
This is called when the map is first loaded
Shows the checkboxes, layer name, legend image for the legend in the sidebar
This function also adds the fish advisory/tissue layers to the map

Parameters:
    layer = fish advisory/tissue ArcGISDynamicMapServiceLayer (e.g. FishLayer)
Returnvalue: none
Original Author: Anne Marie Miller
Creation Date: 9-6-2011 (dd-mm-yyyy)
**********************************************************************************************************************
Change Overview:
Date     Programmer     Description of Change
**********************************************************************************************************************
*/

    var fishLegendHTML="";
    
    //var strDefDoc="Advisories_Definitions.pdf";
    //if (strFishTechOrTissue==="TISSUE"){
        //strDefDoc="Fish_Tissue_Definitions.pdf";
    //}
                
    var items = dojo.map(layer.layerInfos, function(info,index)
    {
        
        if (info.defaultVisibility)
        {
            visible.push(info.id);                          
        }                              
        
        //if this is a Group Layer then add it to layer list (so only show 1 layer for points, lines, polygons)
        if (info.parentLayerId === -1)
        { 
            if (layer.id==="statewideRegionalTechLayer") {
                fishLegendHTML = getLegend(layer.id,info.id,legendInfoStatewides); 
                if (info.id===0) {
                    dojo.byId("RegionalDetailsDiv").innerHTML = fishLegendHTML;  
                }else if (info.id===1) {
                    dojo.byId("StatewideDetailsDiv").innerHTML = fishLegendHTML;
                }         
                //return "<input type='checkbox' class='statewide_list' checked='" + (info.defaultVisibility ? "checked" : "") + "' id='" + info.id + "' value='" + info.id + "' onclick='updateSingleLayerVisiblity(&quot;.statewide_list&quot;,statewideRegionalTechLayer);' /><label for='" + info.id + "'><a href='docs/Advisories_Definitions.pdf#" + info.name + "' title='Show "+ info.name + " Definition' target='_blank'>" + info.name + "</a></label>";
                return "<input type='checkbox' class='statewide_list' checked='" + (info.defaultVisibility ? "checked" : "") + "' id='" + info.id + "' value='" + info.id + "' onclick='updateSingleLayerVisiblity(&quot;.statewide_list&quot;,statewideRegionalTechLayer);' /><label for='" + info.id + "'>" + info.name + "</label>";
            }else { 
//                if ( info.subLayerIds[2] === 3) {  
                    //Only do the legend for the fish symbology layers - be sure to EXCLUDE the selection layers
                    if (info.subLayerIds[2]<=6)  {      
                        fishLegendHTML = getLegend(layer.id,info.subLayerIds[2], legendInfoFishTech);
                        var strLayerTitle="<input type='checkbox' class='fish_list' checked='" + (info.defaultVisibility ? "checked" : "") + "' id='" + info.id + "' value='" + info.subLayerIds + "' onclick='updateTechMapLayerVisibility();' />";            
                        //strLayerTitle=strLayerTitle+ "<label for='" + info.id + "'><a href='docs/" + strDefDoc + "#" + info.name + "' title='Show "+ info.name + " Definition' target='_blank'>" + info.name + "</a></label>";                           
                        strLayerTitle=strLayerTitle+ "<label for='" + info.id + "'>" + info.name + "</label>";                           
                        return strLayerTitle;
                    }
//                }else {
//                    return "";
//                }
            }
        }
        else
        {
            return "";
        }
    });

    if (layer.id==="statewideRegionalTechLayer") {
        dojo.byId("RegionalDetailsTitle").innerHTML = items[0];
        dojo.byId("StatewideDetailsTitle").innerHTML = items[1];
       
    }else{    
        var strSelectionCheckbox="<input type='checkbox' class='selection_list' checked='true' id='SelectedSetCheckbox' onclick='updateSelectedSetVisiblity();'/>";
        if (strFishTechOrTissue==="TISSUE"){
            dojo.byId("FishPopDetailsTitle").innerHTML = items.join(" ");        
            dojo.byId("FishPopDetailsDiv").innerHTML = fishLegendHTML;
            //dojo.byId("SelectedDetailsTitle").innerHTML = "<table class='legendTable'><tr><td class='checkbox'>" + strSelectionCheckbox + "</td><td><img src='images/selectedColor.png' class='legendImage' /></td><td><a href='docs/Advisories_Definitions.pdf#Stations Matching Search' title='Show Stations Matching Search Definition' target='_blank'>Indicates stations that match your search results</a></td></tr></table>";
            //dojo.byId("IdentifyDetailsTitle").innerHTML = "<table class='legendTable'><tr><td><img src='images/identifyColor.png' class='legendImage' /></td><td><a href='docs/Advisories_Definitions.pdf#Selected Station' title='Show Selected Station Definition' target='_blank'>Indicates a station that you clicked on</a></td></tr></table>";
            dojo.byId("SelectedDetailsTitle").innerHTML = "<table class='legendTable'><tr><td class='checkbox'>" + strSelectionCheckbox + "</td><td><img src='images/selectedColor.png' class='legendImage' /></td><td>Indicates stations that match your search results</td></tr></table>";
            dojo.byId("IdentifyDetailsTitle").innerHTML = "<table class='legendTable'><tr><td><img src='images/identifyColor.png' class='legendImage' /></td><td>Indicates a station that you clicked on</td></tr></table>";
       
        }else { //Technical site
            dojo.byId("FishPopDetailsTitle").innerHTML = items.join(" ");
            dojo.byId("FishPopDetailsDiv").innerHTML = fishLegendHTML;
            //dojo.byId("SelectedDetailsTitle").innerHTML = "<table class='legendTable'><tr><td class='checkbox'>" + strSelectionCheckbox + "</td><td><img src='images/selectedColor.png' class='legendImage' /></td><td><a href='docs/Advisories_Definitions.pdf#Advisories Matching Search' title='Show Advisories Matching Search Definition' target='_blank'>Indicates advisories that match your search results</a></td></tr></table>";
            //dojo.byId("IdentifyDetailsTitle").innerHTML = "<table class='legendTable'><tr><td><img src='images/identifyColor.png' class='legendImage' /></td><td><a href='docs/Advisories_Definitions.pdf#Selected Advisory' title='Show Selected Advisory Definition' target='_blank'>Indicates an advisory that you clicked on</a></td></tr></table>";
            dojo.byId("SelectedDetailsTitle").innerHTML = "<table class='legendTable'><tr><td class='checkbox'>" + strSelectionCheckbox + "</td><td><img src='images/selectedColor.png' class='legendImage' /></td><td>Indicates advisories that match your search results</td></tr></table>";
            dojo.byId("IdentifyDetailsTitle").innerHTML = "<table class='legendTable'><tr><td><img src='images/identifyColor.png' class='legendImage' /></td><td>Indicates an advisory that you clicked on</td></tr></table>";

        }
        
        
    }
        
    map.addLayer(layer);        

}

function init(fishMSName, strAdvNum)
{
    //setup some defaults for ajax
    setupAjax();

    //identify proxy page to use if the toJson payload to the geometry service is greater than 2000 characters.
    //If this null or not available the buffer operation will not work.  Otherwise it will do a http post to the proxy.
    esriConfig.defaults.io.proxyUrl = proxyURL;
    esriConfig.defaults.io.alwaysUseProxy = false;
    
    //Hide the popup div
    esri.hide(dojo.byId("waterbodyPopUpDiv"));
    
    //Start of new query
    boolNewQuery=true;
        
    //Set global var so know if site is Fish Tissue or Technical Query site
    if (fishMSName===fishTechMSName) {
        strFishTechOrTissue="ADV";
    }else if (fishMSName===fishTissueMSName) {
        strFishTechOrTissue="TISSUE";
//    }else if (fishMSName===fishTissueSummaryMSName) {
//        strFishTechOrTissue="TISSUE_SUMMARY";
    }else {
        alert("Error loading page.  Map Service is not valid. " + fishMSName);        
    }
    
    //Store LegendInfo now since have to make call to Legend Service.
    storeLegendInfo(serverName,fishMSFolder + "/" + fishMSName); 
    
    //Add Fish Layer
    var imageParameters = new esri.layers.ImageParameters();
    imageParameters.layerIds = [0];
    imageParameters.layerOption = esri.layers.ImageParameters.LAYER_OPTION_SHOW;
    FishLayer = new esri.layers.ArcGISDynamicMapServiceLayer("https://" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + fishMSName + "/MapServer", { "imageParameters": imageParameters });
    FishLayer.id = "FishLayer";
    FishLayer.setVisibleLayers([1,2,3,4,5,6]);
    legendLayers.push({ layer: FishLayer, title: "Fish Advisories" });
        
    
    //this is used on general site but we need to set true here for identify on other sites
    boolFishLoaded=true;
    
    
    //initExtent = new esri.geometry.Extent({"xmin":-9720000,"ymin":3945000,"xmax":-8355000,"ymax":4490000,"spatialReference":{"wkid":102100}});               
    //Worked w/ 600px map height
    //initExtent = new esri.geometry.Extent({"xmin":-16591000,"ymin":2218000,"xmax":-5672000,"ymax":6572000,"spatialReference":{"wkid":102100}});
    //if (strFishTechOrTissue==="TISSUE"){  
    initExtent = new esri.geometry.Extent({"xmin":-14652000,"ymin": 2431000,"xmax": -6674000,"ymax": 6560000,"spatialReference":{"wkid":102100}});
    //}else{ 
    //    initExtent = new esri.geometry.Extent({"xmin":-14623000,"ymin":2093000,"xmax":-6644000,"ymax":6369000,"spatialReference":{"wkid":102100}});
    //}
    map = new esri.Map("map",{extent:selectExtent, wrapAround180:true, logo:false});

    //Identify initialization and call the tech query on the onLoad of map
    var identifyLayer = "https://" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + fishMSName + "/MapServer";
    
    if (fishMSName===fishTechMSName) {
        statewideIdentifyLayer = "https://" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + stateRegionalTechMSName + "/MapServer";
//        statewideIdentifyLayer="http://" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + advWhereULiveMSName + "/MapServer";

    }
    
    dojo.connect(map, "onLoad", function()
    {
        //alert("width=" + map.width.toString());
        map.setExtent(initExtent);
        if (map.width > 1300) {
            map.setLevel(5);
        }else {
            map.setLevel(4);
        }
        //Add Scalebar
        var scalebar = new esri.dijit.Scalebar({map: map,scalebarUnit:"english"}); //metric or english
        
        initIdentifyFunctionality(map, identifyLayer, [1,2,3]);       
        doTechnicalQuery();
        if (strAdvNum!=null){
        //alert (dojo.byId("ctl00_cpContent_pnlMap_StateSelected").value);
            QueryByAdvNum(strAdvNum);
        }
    });

    //Listen for infoWindow onHide event
    dojo.connect(map.infoWindow, "onHide", function()
    {
        map.graphics.clear();
        numIdentifyPopUpCounter=0;
        textShow="";
        boolFedText=false;        
        dojo.byId(strAdvNumHiddenVarName).value="";
    });    
    
    
    //Add base layers to the map
    addBaseLayers();          
    
    
    
    if (fishMSName===fishTechMSName) {
        //Add Statewides and Regionals Layers
        var imageParameters2 = new esri.layers.ImageParameters();
        imageParameters2.layerIds = [0,1];
        imageParameters2.layerOption = esri.layers.ImageParameters.LAYER_OPTION_SHOW;
        statewideRegionalTechLayer = new esri.layers.ArcGISDynamicMapServiceLayer("https://" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + stateRegionalTechMSName + "/MapServer", { "imageParameters": imageParameters2 });
        statewideRegionalTechLayer.id="statewideRegionalTechLayer";
        statewideRegionalTechLayer.setVisibleLayers([0,1]);
        statewideRegionalTechLayer.setOpacity(0.6);
        legendLayers.push({layer:statewideRegionalTechLayer,title:'Active Statewide and Regional Advisories'});
        
        statewideBorder = new esri.layers.ArcGISDynamicMapServiceLayer("https://" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + stateRegionalActiveMSName + "/MapServer", { "imageParameters": imageParameters2 });
        statewideBorder.setVisibleLayers([2]);
    }

    //Add FeatureLayers for Selection
    zoomExtent = initExtent;
    addSelectionFeatureLayers(fishMSName);
    
    //Add Zoom tools to zoomDiv
    //addZoomTools();
                       
    
    //Add the Legend
    //addLegend(legendLayers);
    
    //Store LegendInfo now since have to make call to Legend Service.
    //storeLegendInfo(serverName,fishMSFolder + "/" + fishTechMSName);
        
    //Add identify
    dojo.connect(map.infoWindow, "onShow", function()
    {
        esri.show(dojo.byId("idResultsBorder"));
        dijit.byId("idResultsBorder").resize();
    });

       
    //Add the Other layers 
    //Build Layer List           
    if (FishLayer.loaded)
    {
        buildTechMapLayerList(FishLayer);
    }
    else
    {
        dojo.connect(FishLayer, "onLoad", function()
        {
            buildTechMapLayerList(FishLayer);
            //Just do this the 1st time the map loads.
            updateTechMapLayerVisibility();
        });      
    }
    
    if (fishMSName===fishTechMSName) {
        //Build Layer List - Statewides/Regionals Layers
        if (statewideRegionalTechLayer.loaded) {
            storeLegendInfo(serverName,fishMSFolder+ "/" + stateRegionalTechMSName);    
        }
        else {    
          dojo.connect(statewideRegionalTechLayer, "onLoad", function() {  storeLegendInfo(serverName,fishMSFolder+ "/" + stateRegionalTechMSName); });
        }
        if (statewideBorder.loaded) {
            map.addLayer(statewideBorder);    
        }
        else {
          dojo.connect(statewideBorder, "onLoad", function() {  map.addLayer(statewideBorder); });
        }
             
        //Make sure order of layers is correct w/ fish advisories on top
        dojo.connect(map, "onLayerAdd", function(layer) { if (layer===statewideRegionalTechLayer) {map.reorderLayer(statewideRegionalTechLayer,2);} if (layer===statewideBorder) {map.reorderLayer(statewideBorder,3);} });  

    }
    if (fishMSName===fishTissueMSName) {
        //Make sure order of layers is correct w/ fish advisories on top
        dojo.connect(map, "onLayerAdd", function(layer) { if (layer===FishLayer) {map.reorderLayer(FishLayer,2);} });       
    }
    
    //Make the selection now that met user query 
    //dojo.connect(map, 'onLoad', doTechnicalQuery);

    //Prevent zooming in too far on basemaps
    dojo.connect(map, "onZoomEnd", function(extent, zoomFactor, anchor, level)
    {
        var minLevel = streetLayer.tileInfo.lods.length - 1;
        if (level >= minLevel)
        {
            map.setLevel(level - 1);
        }
        //Don't let zoom out those last 2 tick marks.
        var maxLevel = 2;
        if (level < maxLevel)
        {
            map.setLevel(maxLevel);
        }
    });

    dojo.connect(map, "onZoomEnd", function(extent, zoomFactor, anchor, level)
    {
        var minLevel = imageryLayer.tileInfo.lods.length - 1;
        if (level >= minLevel)
        {
            map.setLevel(level - 1);
        }
        //Don't let zoom out those last 2 tick marks.
        var maxLevel = 2;
        if (level < maxLevel)
        {
            map.setLevel(maxLevel);
        }
    });
          
    //resize the map when the browser resizes
    var resizeTimer;
    dojo.connect(map, "onLoad", function(theMap)
    {
        dojo.connect(dijit.byId("map"), "resize", function()
        {
            //resize the map if the div is resized
            clearTimeout(resizeTimer);
            resizeTimer = setTimeout( function()
            {
                map.resize();
                map.reposition();
            }, 500);
        });
    });

    //Hide loading message
    esri.hide(dojo.byId("mapStatus"));
}

function SetStateExtent()
{
    if (ddlState.GetItemCount() == 2)
    {
        getStateExtent(ddlState.GetItem(1).value, false, true);
    }
    else if (ddlState.GetText() == 'All')    
    {         
        getStateExtent('US', false, true);
    }
    else
    {
        getStateExtent(ddlState.GetValue(), false, true);
    }
}
    
function doTechnicalQuery()
{
    //only do the query if DoQuery flag is set
    if (dojo.byId("ctl00_cpContent_pnlQuery_hfDoMapQuery").value == "1")
    {
        //Show loading message
        esri.show(dojo.byId("mapStatus")); 
        
        var hfAdvClicked = dojo.byId("ctl00_cpContent_pcResults_hfAdvisoryClicked").value;  
        var boolOKToRun=true;
        
        //If came from adv num click from report then need to check that the user
        //has some selections made in the dropdowns - if not, we don't want to run  a
        //query on everything.
        if (hfAdvClicked==="1") {
            boolOKToRun = CheckSelections(); 
        }
        
        //Set hidden var back to 0
        dojo.byId("ctl00_cpContent_pcResults_hfAdvisoryClicked").value="0";
        
        //Start of new query
        boolNewQuery=true;
        numCompletes=0;
        boolAdvNumClickFromReport=false;  
        boolQueryLimitHit=false;
        
        if (boolOKToRun){
            
            //Hide the selection layers until we are done so they don't try to start drawing when way zoomed out.
            fLayerPoints.hide();
            fLayerLines.hide();
            fLayerPolygons.hide();
        
            //Make sure selection Layers are turned on.
            inputs = dojo.query(".selection_list");
            dojo.forEach(inputs,function(input){
                input.checked=true;
            });
            
            //moved to end of process
    //        fLayerPoints.show();
    //        fLayerLines.show();
    //        fLayerPolygons.show();      
            
            
            //if ((stateExtent===null) || (stateExtent===undefined)){
                //stateExtent=selectExtent;
                
            SetStateExtent();
            
            //}
        
        }
        
    }
}

function doTechnicalQuery_Complete(listAdvNums)
{
    //query for points,lines,polygons from identifylayer
//    var strMagicNumber = "";
//    strMagicNumber = dojo.byId("ctl00_cpContent_pcResults_hfMagicNumber").value;
    //var ncExtent = new esri.geometry.Extent({"xmin":-9554000 ,"ymin": 3941000 ,"xmax":-8190000 ,"ymax":4485000,"spatialReference":{"wkid":102100}});

    //Setup the query for the selection
    var queryGeom = new esri.tasks.Query();
    queryGeom.outSpatialReference = { "wkid": 102100 };
    queryGeom.returnGeometry = false;
        
    if ((stateExtent===null) || (stateExtent===undefined)){
        stateExtent=selectExtent;
    }
    queryGeom.geometry = stateExtent; //initExtent; //ncExtent;
  
    //queryGeom.where = "SOURCE_FEATUREID IN (select advnum from nlfwa.web_session_results where session_id = '" + strMagicNumber + "')";
    //queryGeom.where = "(SOURCE_FEATUREID,substr(SOURCE_ORIGINATOR,1,2)) IN (select advnum,state from web_session_results@" + strDBLink + " where session_id = '" + strMagicNumber + "')";
    //queryGeom.where = "session_id = '" + strMagicNumber + "'";
    
//    if (strFishTechOrTissue==="TISSUE") {
//        var strQueryPoints = "comid in (select comid from RAD_FSHTD_P_SDE_V where session_id = '" + strMagicNumber + "')";
//        var strQueryPolygons = "comid in (select comid from RAD_FSHTD_A_SDE_V where session_id = '" + strMagicNumber + "')";
//        var strQueryLines = "comid in (select comid from RAD_FSHTD_L_SDE_V where session_id = '" + strMagicNumber + "')";
//        
//        queryGeom.where= strQueryPoints;
//        fLayerPoints.selectFeatures(queryGeom, esri.layers.FeatureLayer.SELECTION_NEW, null, function(error) { arcgisErrorHandler(error); });
//        
//        queryGeom.where= strQueryPolygons;
//        fLayerPolygons.selectFeatures(queryGeom, esri.layers.FeatureLayer.SELECTION_NEW, null, function(error) { arcgisErrorHandler(error); });
//        
//        queryGeom.where= strQueryLines;
//        fLayerLines.selectFeatures(queryGeom, esri.layers.FeatureLayer.SELECTION_NEW, null, function(error) { arcgisErrorHandler(error); });
//    
//    }else {
//        var strQueryPoints = "comid in (select comid from RAD_FISH_P_SDE_V where session_id = '" + strMagicNumber + "')";
//        var strQueryPolygons = "comid in (select comid from RAD_FISH_A_SDE_V where session_id = '" + strMagicNumber + "')";
//        var strQueryLines = "comid in (select comid from RAD_FISH_L_SDE_V where session_id = '" + strMagicNumber + "')";
        if (listAdvNums != null) {
            var strQuery= "SOURCE_FEATUREID in( " + listAdvNums + ")";
            
            queryGeom.where= strQuery;

            
//            if (featType==="Points") {
                fLayerPoints.selectFeatures(queryGeom, esri.layers.FeatureLayer.SELECTION_NEW, null, function(error) { arcgisErrorHandler(error); });
//            }else if (featType==="Polygons"){    
                fLayerPolygons.selectFeatures(queryGeom, esri.layers.FeatureLayer.SELECTION_NEW, null, function(error) { arcgisErrorHandler(error); });
//            }else if (featType==="Lines"){           
                fLayerLines.selectFeatures(queryGeom, esri.layers.FeatureLayer.SELECTION_NEW, null, function(error) { arcgisErrorHandler(error); });
//            }
        }else {
            arcgisErrorHandler("No AdvNums found.");
        }
        
//    }
    
    

}