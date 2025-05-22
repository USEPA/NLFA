/*global dojo,doIdentify,esri,dijit,addToMap,layerTabContent,bldgResults,parcelResults,queryTask,query*/

//In this code need to change "identifyParams.layerIds" (only if layer order changes), queryTask and identifyTask when move to different server.

var map, identifyTask, identifyParams, queryGeomTask, idLayer, arrayIDs, identifyQuery;
var layer2results, layer3results, layer4results;
var boolNoIdentifyResults_Individual=false;
var boolNoIdentifyResults_Statewide=false;
var strTitleIdentifyResults = "Fish Advisory Information";
var boolAdvNumClickFromReport=false; //boolean saying if user came into map by clicking Advnum from report.
var boolStatewideFound=false;
var numIdentifyPopUpCounter=0;
var textShow="";
var stateAdvNumClicked="";
       
function initIdentifyFunctionality(map, identifyLayer,arrayLayerIDs) {       
    dojo.connect(map, "onClick", doIdentify);
    //dojo.connect(map, "onClick", executeQueryGeomTask);
        
    //build query - this is the NLFA Attribute DB (ADVISORY_INFO view - layer 5 in FISH_POP map service)
    //queryTask = new esri.tasks.QueryTask("http://rtpwweb75.rti.org:85/ArcGIS/rest/services/NLFA/FISH/MapServer/4");
    if (strFishTechOrTissue==="ADV") {
        if (boolGeneralSite) {
            queryTask = new esri.tasks.QueryTask("https://" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + fishGenMSName + "/MapServer/" + advisoryInfoViewGenLayerNum );
        }else {
            queryTask = new esri.tasks.QueryTask("https://" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + fishTechMSName + "/MapServer/" + advisoryInfoViewTechLayerNum);
        }
        
        strTitleIdentifyResults="Fish Advisory Information";    
        
        //Set up params for statewide/regional identify query/params        
        statewideIdentifyTask = new esri.tasks.IdentifyTask(statewideIdentifyLayer);

        statewideIdentifyParams = new esri.tasks.IdentifyParameters();
        statewideIdentifyParams.tolerance = 5;
        statewideIdentifyParams.returnGeometry = false;
        statewideIdentifyParams.layerIds = [0,1];
        statewideIdentifyParams.layerOption = esri.tasks.IdentifyParameters.LAYER_OPTION_ALL;        
        statewideIdentifyParams.width  = map.width;
        statewideIdentifyParams.height = map.height;
        statewideIdentifyParams.spatialReference = { "wkid": 102100 };  
        
    }else if (strFishTechOrTissue==="TISSUE"){
        queryTask = new esri.tasks.QueryTask("https://" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + fishTissueMSName + "/MapServer/" + tissueViewLayerNum);
        strTitleIdentifyResults="Fish Tissue Sampling Station Information";
//    }else if (strFishTechOrTissue==="TISSUE_SUMMARY"){
//        queryTask = new esri.tasks.QueryTask("http://" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + fishTissueSummaryMSName + "/MapServer/" + tissueSummaryViewLayerNum );    
//        strTitleIdentifyResults="Fish Tissue Sampling Station Information";
    }

    //build query filter
    identifyQuery = new esri.tasks.Query();
    identifyQuery.returnGeometry = false;
    map.infoWindow.resize(415, 250);
    if (strFishTechOrTissue==="ADV") {        
        identifyQuery.outFields = ["ADVISORY_NUMBER","ADVISORY_NAME","STATE","URL","CURR_DATE","ADV_TYPE","STATE_ABBR"];
    }else if (strFishTechOrTissue==="TISSUE"){
        identifyQuery.outFields = ["STATION_ID","STATE","SITENAME","LOCATION","MOST_RECENT_SAMPLE_DATE"]; //,"SPECIES","PARAMETER","SAMPLEDATE"];
    }
    //Identify from click on the Fish SDE layers
    identifyTask = new esri.tasks.IdentifyTask(identifyLayer);
    
    identifyParams = new esri.tasks.IdentifyParameters();
    identifyParams.tolerance = 5;
    identifyParams.returnGeometry = false;
    identifyParams.layerIds = arrayLayerIDs;
    identifyParams.layerOption = esri.tasks.IdentifyParameters.LAYER_OPTION_ALL;
    //identifyParams.layerOption =esri.layers.ImageParameters.LAYER_OPTION_SHOW;
    identifyParams.width  = map.width;
    identifyParams.height = map.height;
    identifyParams.spatialReference = { "wkid": 102100 }; 
    
    
    map.infoWindow.setContent(dijit.byId("idResultsBorder").domNode);
    map.infoWindow.setTitle("<span id='idResultsTitle'>" + strTitleIdentifyResults + "</span>");
    
    //set these global vars so can get selected geometry to show on map
    idLayer = identifyLayer;
    arrayIDs = arrayLayerIDs;    
}

function updateIdentifyLayer(identifyLayer,arrayLayerIDs) {
    identifyTask="";
    identifyTask = new esri.tasks.IdentifyTask(identifyLayer);
    identifyParams.layerIds = arrayLayerIDs;  
    
    idLayer = identifyLayer;
    arrayIDs = arrayLayerIDs;
    //queryGeomTask = new esri.tasks.QueryTask(identifyLayer);  
}

function doIdentify(evt) {
        map.infoWindow.hide();
        map.graphics.clear();
        //Show loading message
        esri.show(dojo.byId("mapStatus"));
        
        boolAdvNumClickFromReport=false;
        
        var wbPopUpDiv = dojo.byId("waterbodyPopUpDiv");
        if(wbPopUpDiv){
            esri.hide(dojo.byId("waterbodyPopUpDiv"));
        }  
              
        
        identifyParams.geometry = evt.mapPoint;        
        identifyParams.mapExtent = map.extent;
        identifyParams.width  = map.width;
        identifyParams.height = map.height;        
        identifyTask.execute(identifyParams, function(idResults) { GetAdvNumFromClick(idResults, evt); executeQueryGeomTask(false); }, function(error) { arcgisErrorHandler(error);});                 
//        //Check for identify results in the statewide and regional layers for the Tech and General sites.
//        if (strFishTechOrTissue==="ADV") {
//            statewideIdentifyParams.geometry = evt.mapPoint;        
//            statewideIdentifyParams.mapExtent = map.extent;
//            statewideIdentifyParams.width  = map.width;
//            statewideIdentifyParams.height = map.height; 
//            statewideIdentifyTask.execute(statewideIdentifyParams, function(idResults) { GetStatewideFromClick(idResults, evt); }, function(error) { alert("Statewide/Regional identify error. " + error); } );                 
//        }
}

function GetAdvNumFromClick(idResults, evt) {
    popFish = {displayFieldName:"Advisory_Number",features:[]};
    //popFish_L = {displayFieldName:"Advisory_Number",features:[]};
    //popFish_A = {displayFieldName:"Advisory_Number",features:[]};
        
    var il;
    var currentAdvNum="";
    var newAdvNum="";
    //var showGeom=true;
    
    if (idResults.length ===0) {
          
        if (strFishTechOrTissue==="ADV") {
            boolNoIdentifyResults_Individual=true;
            //var s="No results were found.  Please zoom in closer to identify on another advisory.";
            var s="";
            showIdentifyPopUp(s,evt);
        }else if (strFishTechOrTissue==="TISSUE"){
            alert("No results were found.  Please zoom in closer to identify on another fish tissue sampling station.");
            //Hide loading message
            esri.hide(dojo.byId("mapStatus"));
        }        
          
    }else {
        //If we found results then we can do something.
        for (var i=0, il=idResults.length; i<il; i++) {
          var idResult = idResults[i];
          //if (idResult.layerId === 0) {
            if (!popFish.displayFieldName) {popFish.displayFieldName = idResult.displayFieldName};
            popFish.features.push(idResult.feature);
            
            newAdvNum=popFish.features[i].attributes["SOURCE_FEATUREID"];
            if (currentAdvNum == "") {
                currentAdvNum = newAdvNum;
            }else {
                if (currentAdvNum != newAdvNum) {
                    if (strFishTechOrTissue==="ADV") {
                        alert("More than one advisory was found.  Results will be shown for the first advisory.  You should zoom in closer to identify on another advisory.");
                    }else if (strFishTechOrTissue==="TISSUE"){
                        alert("More than one fish tissue sampling station was found.  Results will be shown for the first fish tissue sampling station.  You should zoom in closer to identify on another fish tissue sampling station.");
                    }
                    //showGeom=false;
                    break;
                }
            }
        }
        
        DoAdvNumQuery(currentAdvNum,evt);
           
//        dojo.byId(strAdvNumHiddenVarName).value=currentAdvNum;
//           
//        //Now that we have the advnum, go to NLFA and get the attribute info and show it.

//        if (strFishTechOrTissue==="ADV") {  
//            identifyQuery.where = "Advisory_Number=" + currentAdvNum;      
//            queryTask.execute(identifyQuery, function(results) { showResults(results, evt); });
//        }else if (strFishTechOrTissue==="TISSUE"){
//            identifyQuery.where = "STATION_ID='" + currentAdvNum + "'";
//            queryTask.execute(identifyQuery, function(results) { showTissueResults(results, evt); });        
//        }          
                        
    
        //alert("AdvNum = " + currentAdvNum);
    }
    
    //Check for identify results in the statewide and regional layers for the Tech and General sites.
    if (strFishTechOrTissue==="ADV") {
        statewideIdentifyParams.geometry = evt.mapPoint;        
        statewideIdentifyParams.mapExtent = map.extent;
        statewideIdentifyParams.width  = map.width;
        statewideIdentifyParams.height = map.height; 
        statewideIdentifyTask.execute(statewideIdentifyParams, function(idResults) { GetStatewideFromClick(idResults, evt); }, function(error) { arcgisErrorHandler(error);} );                 
    }
    
}

//function CheckForNoIdentifyResultsFound(evt){
//    if ((boolNoIdentifyResults_Individual) && (boolNoIdentifyResults_Statewide)){
//        if (strFishTechOrTissue==="ADV") {
//            //alert("No results were found.  Please zoom in closer to identify on another advisory.");
//            var s="No results were found.  Please zoom in closer to identify on another advisory.";
//            showIdentifyPopUp(s,evt);
//        }else if (strFishTechOrTissue==="TISSUE"){
//            alert("No results were found.  Please zoom in closer to identify on another fish tissue sampling station.");
//        }
//        
//        //Hide loading message
//        esri.hide(dojo.byId("mapStatus"));
//    }
//    
//    if ((boolNoIdentifyResults_Individual) || (boolNoIdentifyResults_Statewide)){
//        var s="";
//        showIdentifyPopUp(s,evt);
//    }
//            
//    //Reset variables back to false
//    boolNoIdentifyResults_Individual=false;
//    boolNoIdentifyResults_Statewide=false;  
//      
//    
//}

function GetStatewideFromClick(idResults, evt){
    //Show loading message
    esri.show(dojo.byId("mapStatus"));
        
    //Get the State from the user click and then we can query for all the statewide/regional advisory numbers 
    if (idResults.length !=0) {
        //Rather than querying ADVISORY_INFO just look at SYMBOLOGY field on state/regional layers
        //because just need to say if statewide,regional, coastal - don't need details info.
        boolFedText=false;
        showStatewideResults(idResults, evt); 
        //CheckForNoIdentifyResultsFound(evt);
        
//        for (var i=0, il=idResults.length; i<il; i++) {
//            //Get the state the user clicked    
//            var state = idResults[i].feature.attributes["ST"];    
//            
//            
//             
//            
//            //Query the ADVISORY_INFO view for the state.              
////            identifyQuery.where = "STATE_ABBR='" + state + "' AND (ADV_TYPE='Statewide' or ADV_TYPE='Coastal' or ADV_TYPE='Regional')";      
////            queryTask.execute(identifyQuery, function(results) { showStatewideResults(results, evt); CheckForNoIdentifyResultsFound(evt); });            
//        }   
         
    }else {
        boolNoIdentifyResults_Statewide=true;
        var s = "";
        showIdentifyPopUp(s,evt);
        //Check if we have no individual advisories and no statewide advisories b/c if we found neither
        // then we need to let the user know.
        //CheckForNoIdentifyResultsFound(evt);
    }
        
}

function showStatewideResults(results, evt){
    var s = "";
    var urlField="URL";
    var strName="";    
    
    var len;
    var strSymbologyField;
    if (evt!=null){ //if come in from identify then have identifyResults
        len =results.length;
        strSymbologyField="SYMBOLOGY";
    }else { // if come in from query then have queryResults
        len=results.features.length;
        //strSymbologyField="NLFWA.ACTIVE_STATEWIDE_SYMBOLOGY.SYMBOLOGY";
        strSymbologyField="SYMBOLOGY";
    }
    if (len === 0) {
//        s="No statewide/regional advisories were found.";
    }else { 
        var arrayText=[]; 
        var strText="";     
        for (var i=0, il=len; i<il; i++) {
           if (evt!=null){ //if come in from identify then have identifyResults
              var featureAttributes = results[i].feature.attributes;
           }else { // if come in from query then have queryResults
              var featureAttributes = results.features[i].attributes;
           }
            //If we have a regional adv (layerId=0) in result then put that in array
            var boolRegional;
            if (evt!=null){ //if come in from identify then have identifyResults
                if (results[i].layerId===0) {
                    boolRegional=true;
                }else {
                    boolRegional=false;
                }
            }else { // if come in from query then have queryResults
                boolRegional=true;
                for (att in featureAttributes) {
                    if (att.toString().indexOf("SYMBOLOGY")!= -1) {
                        boolRegional=false;
                    } 
                    //Get the name of the state
                    if (att.toString().indexOf("NAME")!= -1) {
                        strName = results.features[i].attributes[att];  
                    }            
                }
            }
              
            if (boolRegional) {
                strText="Regional";
                if (arrayText.toString().indexOf(strText)=== -1){
                    arrayText.push(strText);
                }
            }
            //Write to an array if we have statewide, coastal, regional types of advisories at the point of click.                
            //Check statewide layer here
            if (boolRegional===false) {
                for (att in featureAttributes) {  
                
                    if (att===strSymbologyField) {          
                        var strVal=featureAttributes[att];
                        if (strVal===null) {
                            strVal="";
                        }
              
                        if ((strVal==2) || (strVal==1)){
                            strText="Statewide";
                            if (arrayText.toString().indexOf(strText)=== -1){
                                arrayText.push(strText);
                            }
                        }
                        if ((strVal==3) || (strVal==1)){
                            strText="Statewide Coastal";
                            if (arrayText.toString().indexOf(strText)=== -1){
                                arrayText.push(strText);
                            }
                        }                                                               
                    } //if (att==="SYMBOLOGY"
                } // for (att in
                
            }  //if (boolRegional                           
        }  // end for (var i=0) 
        
        //Now write out the text for the popup.
        if (evt!=null){ //if come in from identify 
            if (arrayText.length === 0) {
                s = "<p>A <a href='http://water.epa.gov/scitech/swguidance/fishshellfish/fishadvisories/advisory.cfm' target='_blank' title='Refer to EPA Federal Consumption Advice'>Federal fish advisory</a> applies to all waters in the United States"; 
            }else {
            s = "<p>A <a href='http://water.epa.gov/scitech/swguidance/fishshellfish/fishadvisories/advisory.cfm' target='_blank' title='Refer to EPA Federal Consumption Advice'>Federal fish advisory</a> applies to all waters in the United States.  At this location there is also a "; 
            }
        }else { // if come in from waterbody query then have queryResults  
            //if (numWbPopUpCounter ===1){ 
            if (boolFedText===false) { 
                if (arrayText.length === 0) {
                    s = "<p>A <a href='http://water.epa.gov/scitech/swguidance/fishshellfish/fishadvisories/advisory.cfm' target='_blank' title='Refer to EPA Federal Consumption Advice'>Federal fish advisory</a> applies to all waters in the United States"; 
                }else {
                s = "<p>A <a href='http://water.epa.gov/scitech/swguidance/fishshellfish/fishadvisories/advisory.cfm' target='_blank' title='Refer to EPA Federal Consumption Advice'>Federal fish advisory</a> applies to all waters in the United States.  In " + strName + " there is also a ";
                } 
                boolFedText=true;
            }               
        }        
        var numCnt=0;               
        for (var strElem in arrayText){
          numCnt=numCnt+1;
          //last val in array
          if (numCnt===arrayText.length){
                  if (evt!=null){ //identify
                      if (arrayText.length > 1) {
                        s= s + ", and a ";
                      }
                  }else {  //waterbody query
                     if (numWbPopUpCounter ===2){
                        if ((numCnt!=1) || (s ==="")) {
                            s= s + ", and a "; 
                        }            
                     }else{
                        if (numCnt!=1){
                            s=s + ", a ";
                        }
                     }      
                  }             
           }else {
                  if (evt!=null){ //identify
                      if (numCnt!=1) {              
                        s=s + ", a ";    
                      }
                  
                  }else {  //waterbody query
                      if (numWbPopUpCounter ===1){
                           if (numCnt!=1) {              
                                s=s + ", a ";    
                           }
                      }else {
                           //only add the comma if we have text that needs it.
                          if (s.charAt(s.length - 2) != "a") {
                            s=s + ", a ";
                          }
                      }
                  }
           }
           //s = s + "<a href='/docs/Advisories_Definitions.pdf' target='_blank' title='Advisories Definition of Terms'>" + arrayText[strElem] + " advisory</a>";     
           s = s + "<a href='" + txtDefinitionsURL + "' target='_blank' title='Advisories Definition of Terms'>" + arrayText[strElem] + " advisory</a>";     
        }  
        if ((evt!=null) || (numWbPopUpCounter ===2)){ //if come in from identify      
            s = s + ".</p>";
        }         
  
    } //end else                
    
    if (evt != null) { //for Identify
        showIdentifyPopUp(s,evt);
    }else { //For General site's waterbody popup
        showWaterbodyPopUp(strTitleIdentifyResults,s);
    }
    
         
//    //dijit.byId("idResults").innerHTML = s;
//    dijit.byId("idResults").setContent(s);
//    if (map.infoWindow.isShowing === false) {
//        map.infoWindow.show(evt.screenPoint, map.getInfoWindowAnchor(evt.screenPoint));
//    }
//    
//    //Hide loading message
//    esri.hide(dojo.byId("mapStatus"));
}

function showIdentifyPopUp(s,evt){
    //This function shows the identify popup.  We get data from both the advisory layers and the statewide/regional layers
    //so don't want to show popup until have both sets of info.
    numIdentifyPopUpCounter=numIdentifyPopUpCounter+1;
    textShow=textShow+s;
    if (numIdentifyPopUpCounter===2){
        if ((boolNoIdentifyResults_Individual) && (boolNoIdentifyResults_Statewide)){
            textShow= "<p>No results were found.  Please zoom in closer to identify on another advisory.</p>";
        }
//        if ((boolNoIdentifyResults_Individual) || (boolNoIdentifyResults_Statewide)){
//            
//        }
        textShow=textShow;     
        dijit.byId("idResults").setContent(textShow);    
        map.infoWindow.show(evt.screenPoint, map.getInfoWindowAnchor(evt.screenPoint));  
        
         //Reset variables back to false
        boolNoIdentifyResults_Individual=false;
        boolNoIdentifyResults_Statewide=false;
        numIdentifyPopUpCounter=0;
        textShow="";
        boolFedText=false;
        //Hide loading message
        esri.hide(dojo.byId("mapStatus"));
    }  
}

function showResults(results,evt) {
    var s = "";
    var urlField="URL";
    
    //handle the case where no advisories are found on the identify
    if (results.features.length === 0) {
        if (evt===null){
            showFederalAdvisoryPopUp();        
        }else {
            s="<p>No advisories were found.  Try zooming in and clicking again.</p>";
        }
    } else
    {
        var curDate = "";
        var advNum = "";
        for (var i = 0, il = results.features.length; i < il; i++)
        {
          var featureAttributes = results.features[i].attributes;
          for (att in featureAttributes)
          {
            var strVal=featureAttributes[att];
            if (strVal === null)
            {
                strVal="";
            }
            //use results.fieldaliases[att] instead of att to get field alias rather than actual field name
            if (att === "STATE")
            {
                s = s + "<p><b>" + results.fieldAliases[att].replace("_", " ") + ":</b>  " + strVal + "</p>";
            }
            else if (att === "URL")
            {
                //only want the url as a link so dont list it.
            }
            else if (att === "CURR_DATE")
            {
                curDate = strVal;
                // s = s + "<b>CURRENT DATE:</b>  " + curDate + "<br />";            
                //handle case here for statewide/regional advisories b/c just want to mention that here
            }
            else if (att === "ADV_TYPE")
            {
                //Do this if the user clicked advnum from report
                if (boolAdvNumClickFromReport)
                {
                    if ((strVal === "Statewide") || (strVal === "Statewide Coastal") || (strVal === "Regional"))
                    {
                        boolStatewideFound = true;
                        //Zoom to the state for statewide/regional
                        getStateExtent(featureAttributes["STATE_ABBR"],true,false);
                    }
                }
            }
            else if (att === "ADVISORY_NUMBER")
            {
                advNum = strVal;
                s = s + "<p><b>" + results.fieldAliases[att].replace(/_/g, " ") + ":</b>  " + strVal + "</p>";
            }
            else
            {
                if (att != "STATE_ABBR")
                {
                    s = s + "<p><b>" + results.fieldAliases[att].replace(/_/g, " ") + ":</b>  " + strVal + "</p>";
                }
            }
          }
          //Add link to report
          s = s + "<p><a href='" + advisoryDetailsURL + advNum + "' title='View detailed advisory information' target='_blank'>View detailed advisory information</a></p>";
          //Add the disclaimer text now
          if (featureAttributes[urlField] == null)
          {
              s = s + "<p>Information for this advisory is current as of " + curDate + "; please refer to the <a target='newFishWin' title='Refer to the state website for more information.' href='NoStateSite.aspx'> State website</a> for the most current information.</p>";
          }
          else
          {
            s = s + "<p>Information for this advisory is current as of " + curDate + "; please refer to the <a target='newFishWin' title='Refer to the state website for more information.' href='" + featureAttributes[urlField] + "'> State website</a> for the most current information.</p>";
          }  
          s = s + "<hr class='divider' />";
        }        
    }
           
            
    //dijit.byId("idResults").innerHTML = s;
//    dijit.byId("idResults").setContent(s);
    if (evt===null){
        dijit.byId("idResults").setContent(s);
        showWaterbodyPopUp(strTitleIdentifyResults,s);
    }else {
        showIdentifyPopUp(s,evt);
        //map.infoWindow.show(evt.screenPoint, map.getInfoWindowAnchor(evt.screenPoint));
    }
    //Hide loading message
//    esri.hide(dojo.byId("mapStatus"));
}

function showTissueResults(results, evt)
{
    var s = "";
    
    //handle the case where no advisories are found on the identify
    if (results.features.length === 0)
    {
        if (evt === null)
        {
            showFederalAdvisoryPopUp();
        }
        else
        {
            s="<p>No tissue stations were found.  Try zooming in and clicking again.</p>";
        }
    }
    else
    {
        var curDate = "";
        var stationId = "";
        for (var i = 0, il = results.features.length; i < il; i++)
        {
          var featureAttributes = results.features[i].attributes;
          for (att in featureAttributes)
          {
            //use results.fieldaliases[att] instead of att to get field alias rather than actual field name
            var strVal=featureAttributes[att];
            if (strVal === null)
            {
                strVal="";
            }
            else if (att === "STATION_ID")
            {
                stationId = strVal;
            }
            s = s + "<p><b>" + results.fieldAliases[att].replace(/_/g," ") + ":</b>  " + strVal + "</p>";
        }
        //Add link to report
        s = s + "<p><a href='" + fishTissueDetailsURL + stationId + "' title='View detailed station information' target='_blank'>View detailed station information</a></p>";
        s = s + "<hr class='divider' />";
    }        
}
           
    dijit.byId("idResults").setContent(s);
    if (evt===null){
        if (results.features.length != 0) {
            //We are just using a div to show results for waterbody query
            dijit.byId("wbTitle").setContent(strTitleIdentifyResults);
            dijit.byId("wbContent").setContent(s);
            esri.show(dojo.byId("waterbodyPopUpDiv"));
            //map.infoWindow.show(map.toScreen(map.extent.getCenter()));
        }      
    }else {
        map.infoWindow.show(evt.screenPoint, map.getInfoWindowAnchor(evt.screenPoint));
    }
    //Hide loading message
    esri.hide(dojo.byId("mapStatus"));
}

function DoAdvNumQuery (strAdvNum, evt){
    //Queries the ADVISORY_INFO View based on the advnum
    dojo.byId(strAdvNumHiddenVarName).value=strAdvNum.replace("'","''");
    if (strFishTechOrTissue==="ADV") {  
        identifyQuery.where = "Advisory_Number=" + strAdvNum.replace("'","''");      
        queryTask.execute(identifyQuery, function(results) { 
            showResults(results, evt); 
            if (evt===null) {
                var st = results.features[0].attributes["STATE_ABBR"];
                getStatewides(st);
                stateAdvNumClicked = st;
            }
        },function(error) { arcgisErrorHandler(error);});
    }else if (strFishTechOrTissue==="TISSUE"){
        identifyQuery.where = "STATION_ID='" + strAdvNum.replace("'","''") + "'";
        queryTask.execute(identifyQuery, function(results) { 
            showTissueResults(results, evt); 
            if (evt===null) {
                var st = results.features[0].attributes["STATE"];
                stateAdvNumClicked = st;
            }
         },function(error) { arcgisErrorHandler(error);});        
    } 
}
function QueryByAdvNum(strAdvNum) {
//This function is for when user clicks advnum/station from REport - we want to select it like identify (orange)
//and show popup and zoom to it.
    //Now that we have the advnum/stationID, go to NLFA and get the attribute info and show it.
    esri.show(dojo.byId("mapStatus"));
    boolAdvNumClickFromReport=true;
    boolStatewideFound=false; //Says if we have a statewide/regional or not b/c if we do then zoom to state instead
    
    DoAdvNumQuery(strAdvNum, null);
    executeQueryGeomTask(true);

    esri.hide(dojo.byId("mapStatus"));
}


