/*global visible,dojo,esri,webmap,title,subtitle,owner,bingMapsKey,dijit,alert: false,console: false,initFunctionality*/
dojo.require("esri.map");
dojo.require("esri.arcgis.utils");
dojo.require("esri.dijit.Legend");
dojo.require("esri.dijit.Scalebar");
dojo.require("dijit.form.CheckBox");
dojo.require("esri.layers.FeatureLayer");
dojo.require("dijit.dijit");
dojo.require("dijit.layout.BorderContainer");
dojo.require("dijit.layout.ContentPane");
dojo.require("dijit.layout.StackContainer");      
dojo.require("dijit.layout.TabContainer");
dojo.require("dijit.form.Button");
dojo.require("esri.tasks.query");
dojo.require("esri.tasks.identify");
dojo.require("esri.renderer");

// Import my custom info window module for clickable map popup state. 
dojo.require("myModules.InfoWindow");

var map, initExtent;
var streetLayer;
var imageryLayer;
var legendLayers = [];
var FishGen,FishSpecies,FishPollutants,statewideRegionalLayer, statewideRegionalTechLayer, statewideBorder;
var visible=[];
var legendDijit;
var legendInfoFishPop,legendInfoStatewides;
var legendInfoFishPoll;
var legendInfoFishSpecies;
var legendInfoFishTech;
var AKmap, HImap, ASmap, Guammap, PRmap, VImap, NEmap, clickMap;
//"TISSUE" for fish tissue site and "ADV" for technical site and general site
var strFishTechOrTissue="";
var boolGeneralSite=false; //says if general site or not.
var legendHTML="";
var statewideIdentifyLayer="";
var boolQueryLimitHit=false; 

//Set the extents of all the maps including inset maps
//var contUSExtent = new esri.geometry.Extent({"xmin":-16591000,"ymin":2218000,"xmax":-5672000,"ymax":6572000,"spatialReference":{"wkid":102100}});     	 	 	
//var contUSExtent = new esri.geometry.Extent({"xmin":-13842921,"ymin":2820000,"xmax":-7512713,"ymax":6288545,"spatialReference":{"wkid":102100}}); 
//var contUSExtent = new esri.geometry.Extent({"xmin":-13960329,"ymin":2540648,"xmax":-7400000,"ymax":6288545,"spatialReference":{"wkid":102100}});     	 	 	    	 	 	
//var contUSExtent = new esri.geometry.Extent({"xmin":-17396000,"ymin":2051000,"xmax":-3503000,"ymax":7109000,"spatialReference":{"wkid":102100}});     	 	 	    	 	 	
//var contUSExtent = new esri.geometry.Extent({"xmin": -14644000,"ymin": 2800000 ,"xmax":-7400000,"ymax": 6300000,"spatialReference":{"wkid":102100}});  
//var contUSExtent = new esri.geometry.Extent({"xmin":-14142000,"ymin": 2166000,"xmax": -7254000,"ymax": 7204000,"spatialReference":{"wkid":102100}});

//This extent works well with 600px height
//var contUSExtent = new esri.geometry.Extent({"xmin":-14261000,"ymin": 1540000,"xmax": -7373000,"ymax": 6520000,"spatialReference":{"wkid":102100}});

//Extent used for selections if no stateExtent is set - this includes AK but does not include some territories.
var selectExtent = new esri.geometry.Extent({"xmin":-25416000,"ymin": 1086000,"xmax": 2370000,"ymax": 11907000,"spatialReference":{"wkid":102100}});
   
var contUSExtent = new esri.geometry.Extent({"xmin":-14652000,"ymin": 2431000,"xmax": -6674000,"ymax": 6560000,"spatialReference":{"wkid":102100}});
   
var AKExtent=new esri.geometry.Extent({"xmin":-21888660.62,"ymin":6073380.36,"xmax":-13083114.96,"ymax":11943744.13,"spatialReference":{"wkid":102100}});
var HIExtent=new esri.geometry.Extent({"xmin":-18066121.27,"ymin":1960609.61,"xmax":-16965428.06,"ymax":2694405.09,"spatialReference":{"wkid":102100}});      	 	 		 	 	
var PRExtent=new esri.geometry.Extent({"xmin":-7525493.29,"ymin":1962329.45,"xmax":-7250319.98,"ymax":2145778.31,"spatialReference":{"wkid":102100}});
var VIExtent=new esri.geometry.Extent({"xmin":-7279633.58,"ymin":1995464.90,"xmax":-7142046.93,"ymax":2087189.33,"spatialReference":{"wkid":102100}});
var GuamExtent=new esri.geometry.Extent({"xmin":16050094.00,"ymin":1462545.94,"xmax":16187680.65,"ymax":1554270.37,"spatialReference":{"wkid":102100}});
var ASExtent=new esri.geometry.Extent({"xmin":-19018700.51,"ymin":-1621200.09,"xmax":-18984300.85,"ymax":-1598250.99,"spatialReference":{"wkid":102100}});     	 	 	            
ASExtent=ASExtent.expand(1.5);
//var NEastExtent=new esri.geometry.Extent({"xmin":-8490000,"ymin": 5017000,"xmax": -7629000,"ymax": 5639000,"spatialReference":{"wkid":102100}});
var NEastExtent=new esri.geometry.Extent({"xmin":-8452000,"ymin": 5051000,"xmax": -7591000,"ymax": 5673000,"spatialReference":{"wkid":102100}});
NEastExtent=NEastExtent.expand(.8); 

var MSExtent=new esri.geometry.Extent({"xmin":-10202988.9305,"ymin":3522342.97911,"xmax":-9807012.03215,"ymax":4163351.02634,"spatialReference":{"wkid":102100}});
MSExtent=MSExtent.expand(1.4);
var ARExtent=new esri.geometry.Extent({"xmin":-10532818.563,"ymin":3895848.9789,"xmax":-9979168.40383,"ymax":4369605.75183,"spatialReference":{"wkid":102100}});
var MDExtent=new esri.geometry.Extent({"xmin":-8848524.83367,"ymin":4563419.26399,"xmax":-8347434.72874,"ymax":4825776.01979,"spatialReference":{"wkid":102100}});
var AZExtent=new esri.geometry.Extent({"xmin":-12781324.4447,"ymin":3675964.20681,"xmax":-12138858.6978,"ymax":4439700.59296,"spatialReference":{"wkid":102100}});
AZExtent=AZExtent.expand(1.4);
var NHExtent=new esri.geometry.Extent({"xmin":-8077028.88758,"ymin":5265963.01806,"xmax":-7856383.52675,"ymax":5669741.31717,"spatialReference":{"wkid":102100}});
var PAExtent=new esri.geometry.Extent({"xmin":-8963433.71011,"ymin":4825307.38885,"xmax":-8314397.33025,"ymax":5238600.76328,"spatialReference":{"wkid":102100}});
PAExtent=PAExtent.expand(1.5);
var SCExtent=new esri.geometry.Extent({"xmin":-9278916.82057,"ymin":3767702.78608,"xmax":-8738502.21496,"ymax":4193210.88397,"spatialReference":{"wkid":102100}});
var SDExtent=new esri.geometry.Extent({"xmin":-11583654.5186,"ymin":5233107.12665,"xmax":-10735258.957,"ymax":5771654.43436,"spatialReference":{"wkid":102100}});
SDExtent=SDExtent.expand(1.4);
var TNExtent=new esri.geometry.Extent({"xmin":-10053296.3867,"ymin":4161560.82598,"xmax":-9088891.33282,"ymax":4394335.05365,"spatialReference":{"wkid":102100}});
var WAExtent=new esri.geometry.Extent({"xmin":-13898124.2117,"ymin":5707500.65713,"xmax":-13014982.8314,"ymax":6275284.58422,"spatialReference":{"wkid":102100}});
WAExtent=WAExtent.expand(1.4);
var VTExtent=new esri.geometry.Extent({"xmin":-8175070.18952,"ymin":5270487.61859,"xmax":-7955451.75097,"ymax":5624144.48616,"spatialReference":{"wkid":102100}});
VTExtent=VTExtent.expand(1.4);
var NYExtent=new esri.geometry.Extent({"xmin":-8879130.90311,"ymin":4935561.06369,"xmax":-7990233.74854,"ymax":5624019.45166,"spatialReference":{"wkid":102100}});
NYExtent=NYExtent.expand(1.4);
var CTExtent=new esri.geometry.Extent({"xmin":-8207338.3703,"ymin":5005108.45817,"xmax":-7991318.8909,"ymax":5168560.14592,"spatialReference":{"wkid":102100}});
CTExtent=CTExtent.expand(1.4);
var NVExtent=new esri.geometry.Extent({"xmin":-13359059.4662,"ymin":4164133.50578,"xmax":-12694835.5456,"ymax":5161310.04768,"spatialReference":{"wkid":102100}});
var NJExtent=new esri.geometry.Extent({"xmin":-8411699.91604,"ymin":4691443.55575,"xmax":-8224847.25641,"ymax":5065205.28222,"spatialReference":{"wkid":102100}});
NJExtent=NJExtent.expand(1.4);
var UTExtent=new esri.geometry.Extent({"xmin":-12696321.6608,"ymin":4438814.77533,"xmax":-12138395.0521,"ymax":5161221.81565,"spatialReference":{"wkid":102100}});
UTExtent=UTExtent.expand(1.4);
var MAExtent=new esri.geometry.Extent({"xmin":-8182888.93661,"ymin":5039971.21196,"xmax":-7776652.8339,"ymax":5294755.97503,"spatialReference":{"wkid":102100}});
MAExtent=MAExtent.expand(1.4);
var NEExtent=new esri.geometry.Extent({"xmin":-11583184.1938,"ymin":4865932.39798,"xmax":-10609670.3112,"ymax":5312231.67342,"spatialReference":{"wkid":102100}});
var DEExtent=new esri.geometry.Extent({"xmin":-8436809.36298,"ymin":4643336.92224,"xmax":-8347199.06533,"ymax":4842643.87522,"spatialReference":{"wkid":102100}});
var DCExtent=new esri.geometry.Extent({"xmin":-8584932.30197,"ymin":4691870.29833,"xmax":-8561514.46599,"ymax":4721033.88178,"spatialReference":{"wkid":102100}});
//var AKExtent=new esri.geometry.Extent({"xmin":-19951913.2278,"ymin":6652324.10615,"xmax":20021888.1031,"ymax":11554793.5713,"spatialReference":{"wkid":102100}});
var VAExtent=new esri.geometry.Extent({"xmin":-9314704.58975,"ymin":4375286.37421,"xmax":-8367489.26897,"ymax":4788645.33135,"spatialReference":{"wkid":102100}});
VAExtent=VAExtent.expand(1.4);
var RIExtent=new esri.geometry.Extent({"xmin":-8004679.34486,"ymin":5026487.44995,"xmax":-7913543.52495,"ymax":5163796.00895,"spatialReference":{"wkid":102100}});
RIExtent=RIExtent.expand(1.5);
var NMExtent=new esri.geometry.Extent({"xmin":-12139409.7293,"ymin":3675963.55516,"xmax":-11466126.1832,"ymax":4439147.62772,"spatialReference":{"wkid":102100}});
NMExtent=NMExtent.expand(1.4);
//var ASExtent=new esri.geometry.Extent({"xmin":-19051429.9407,"ymin":-1643352.81988,"xmax":-18712985.8494,"ymax":-1231789.61511,"spatialReference":{"wkid":102100}});
//var MPExtent=new esri.geometry.Extent({"xmin":16120547.0462,"ymin":1578411.88905,"xmax":16269835.3889,"ymax":2346215.27574,"spatialReference":{"wkid":102100}});
//var VIExtent=new esri.geometry.Extent({"xmin":-7253477.1646,"ymin":1993522.80734,"xmax":-7181518.0194,"ymax":2092046.58608,"spatialReference":{"wkid":102100}});
//var GUExtent=new esri.geometry.Extent({"xmin":16092726.9697,"ymin":1480571.30861,"xmax":16142346.6308,"ymax":1540528.61772,"spatialReference":{"wkid":102100}});
var ORExtent=new esri.geometry.Extent({"xmin":-13881934.6843,"ymin":5159750.30434,"xmax":-12964631.022,"ymax":5828410.2834,"spatialReference":{"wkid":102100}});
ORExtent=ORExtent.expand(1.4);
//var PRExtent=new esri.geometry.Extent({"xmin":-7569586.3359,"ymin":2017836.35739,"xmax":-7254524.56971,"ymax":2104140.57771,"spatialReference":{"wkid":102100}});
//var HIExtent=new esri.geometry.Extent({"xmin":-19864249.9081,"ymin":2139102.39581,"xmax":-17227335.9627,"ymax":3314347.49774,"spatialReference":{"wkid":102100}});
var OKExtent=new esri.geometry.Extent({"xmin":-11466180.8411,"ymin":3977327.54678,"xmax":-10511973.2092,"ymax":4439429.05516,"spatialReference":{"wkid":102100}});
OKExtent=OKExtent.expand(1.4);
var NDExtent=new esri.geometry.Extent({"xmin":-11582797.4698,"ymin":5769950.56059,"xmax":-10748386.3079,"ymax":6274978.81269,"spatialReference":{"wkid":102100}});
NDExtent=NDExtent.expand(1.4);
var CAExtent=new esri.geometry.Extent({"xmin":-13857273.1869,"ymin":3832929.99166,"xmax":-12705028.2922,"ymax":5162405.15107,"spatialReference":{"wkid":102100}});
CAExtent=CAExtent.expand(1.4);
var WYExtent=new esri.geometry.Extent({"xmin":-12362796.3325,"ymin":5011546.67252,"xmax":-11583042.9293,"ymax":5622450.998,"spatialReference":{"wkid":102100}});
WYExtent=WYExtent.expand(1.4);
var MTExtent=new esri.geometry.Extent({"xmin":-12918627.1292,"ymin":5521044.2295,"xmax":-11581631.1755,"ymax":6275097.25128,"spatialReference":{"wkid":102100}});
MTExtent=MTExtent.expand(1.5);
var MEExtent=new esri.geometry.Extent({"xmin":-7913071.86425,"ymin":5299366.07421,"xmax":-7445612.4907,"ymax":6017431.98137,"spatialReference":{"wkid":102100}});
MEExtent=MEExtent.expand(1.4);
var TXExtent=new esri.geometry.Extent({"xmin":-11871739.0081,"ymin":2978926.94553,"xmax":-10409267.2865,"ymax":4369738.00227,"spatialReference":{"wkid":102100}});
TXExtent=TXExtent.expand(1.4);
var ALExtent=new esri.geometry.Extent({"xmin":-9848794.57848,"ymin":3522127.87212,"xmax":-9449716.3191,"ymax":4164972.17074,"spatialReference":{"wkid":102100}});
ALExtent=ALExtent.expand(1.4);
var INExtent=new esri.geometry.Extent({"xmin":-9807012.47745,"ymin":4547230.60607,"xmax":-9438185.40093,"ymax":5125300.28332,"spatialReference":{"wkid":102100}});
INExtent=INExtent.expand(1.4);
var FLExtent=new esri.geometry.Extent({"xmin":-9755471.99841,"ymin":2801774.86354,"xmax":-8902699.02051,"ymax":3632874.85726,"spatialReference":{"wkid":102100}});
var IDExtent=new esri.geometry.Extent({"xmin":-13051434.0647,"ymin":5159182.82055,"xmax":-12361305.3193,"ymax":6275055.84845,"spatialReference":{"wkid":102100}});
IDExtent=IDExtent.expand(1.4);
var GAExtent=new esri.geometry.Extent({"xmin":-9529523.37704,"ymin":3549361.54638,"xmax":-8989207.95706,"ymax":4163970.69995,"spatialReference":{"wkid":102100}});
GAExtent=GAExtent.expand(1.4);
var IAExtent=new esri.geometry.Extent({"xmin":-10757858.2607,"ymin":4920650.69284,"xmax":-10034345.6906,"ymax":5388572.8186,"spatialReference":{"wkid":102100}});
IAExtent=IAExtent.expand(1.4);
var KSExtent=new esri.geometry.Extent({"xmin":-11360350.9596,"ymin":4438133.35239,"xmax":-10529531.0758,"ymax":4866402.36468,"spatialReference":{"wkid":102100}});
KSExtent=KSExtent.expand(1.4);
var KYExtent=new esri.geometry.Extent({"xmin":-9971054.77143,"ymin":4369242.93697,"xmax":-9124287.81398,"ymax":4742815.72994,"spatialReference":{"wkid":102100}});
KYExtent=KYExtent.expand(1.4);
var LAExtent=new esri.geometry.Extent({"xmin":-10468858.0571,"ymin":3357219.83842,"xmax":-9880538.55585,"ymax":3897898.25721,"spatialReference":{"wkid":102100}});
LAExtent=LAExtent.expand(1.5);
var MOExtent=new esri.geometry.Extent({"xmin":-10661591.2802,"ymin":4300027.37581,"xmax":-9918510.30197,"ymax":4955519.60024,"spatialReference":{"wkid":102100}});
MOExtent=MOExtent.expand(1.4);
var MIExtent=new esri.geometry.Extent({"xmin":-10065329.3558,"ymin":5115567.52796,"xmax":-9141887.31412,"ymax":6157924.69661,"spatialReference":{"wkid":102100}});
MIExtent=MIExtent.expand(1.5);
var NCExtent=new esri.geometry.Extent({"xmin":-9386667.51978,"ymin":3995667.65081,"xmax":-8393502.85285,"ymax":4381855.60448,"spatialReference":{"wkid":102100}});
var OHExtent=new esri.geometry.Extent({"xmin":-9442153.16153,"ymin":4636573.75761,"xmax":-8963245.02358,"ymax":5210108.89125,"spatialReference":{"wkid":102100}});
OHExtent=OHExtent.expand(1.4);
var WIExtent=new esri.geometry.Extent({"xmin":-10340404.3816,"ymin":5234923.69211,"xmax":-9601255.76449,"ymax":5992792.34962,"spatialReference":{"wkid":102100}});
WIExtent=WIExtent.expand(1.4);
var WVExtent=new esri.geometry.Extent({"xmin":-9199933.97209,"ymin":4467236.21941,"xmax":-8651648.1879,"ymax":4959209.99266,"spatialReference":{"wkid":102100}});
var COExtent=new esri.geometry.Extent({"xmin":-12141261.863,"ymin":4438050.84321,"xmax":-11359138.579,"ymax":5012849.66638,"spatialReference":{"wkid":102100}});
COExtent=COExtent.expand(1.4);
var ILExtent=new esri.geometry.Extent({"xmin":-10187189.2439,"ymin":4434967.51978,"xmax":-9687014.85302,"ymax":5237432.79968,"spatialReference":{"wkid":102100}});
var MNExtent=new esri.geometry.Extent({"xmin":-10824617.7838,"ymin":5388291.20923,"xmax":-9961244.85263,"ymax":6340332.34374,"spatialReference":{"wkid":102100}});
 
var stateExtent;

//says if the fish layers are loaded or not - for general site b/c not loading till user selects a waterbody
var boolFishLoaded=false;

//Variable for advisory number hidden var name - it's in a different panel in General site than tissue and tech
//It's set here for technical/tissue sites and it's value is set in initFishMap for General site.
var strAdvNumHiddenVarName="ctl00_cpContent_pcResults_AdvisoryNumber";

function storeLegendInfo(serverName,mapServiceName) {
    if (mapServiceName != "") {
        var legendInfo;
        var legendServiceJson="//" + serverName + "/ArcGIS/rest/services/" + mapServiceName + "/MapServer/legend?f=json&callback=?";                       
        
        //$.getJSON(legendServiceJson, null, function (data)
        var jsonCall = $.ajax({ url: legendServiceJson })
            .done(function (data){               
            legendInfo = data.layers;
            if (mapServiceName.toString().indexOf(fishGenMSName) != -1) {
                legendInfoFishPop=legendInfo;
                buildLayerList(FishGen);    
//            } else if (mapServiceName.toString().indexOf(fishPollMSName) != -1) {
//                legendInfoFishPoll=legendInfo;    
//            } else if (mapServiceName.toString().indexOf(fishSpeciesMSName) != -1) {
//                legendInfoFishSpecies=legendInfo;    
            }else if (mapServiceName.toString().indexOf(fishTechMSName) != -1) {
                legendInfoFishTech=legendInfo;
            }else if (mapServiceName.toString().indexOf(fishTissueMSName) != -1) {
                legendInfoFishTech=legendInfo;
            }else if (mapServiceName.toString().indexOf(stateRegionalActiveMSName) != -1) {
                legendInfoStatewides=legendInfo;
                buildLayerList(statewideRegionalLayer);                
            }else if (mapServiceName.toString().indexOf(stateRegionalTechMSName) != -1) {
                legendInfoStatewides=legendInfo;
                buildTechMapLayerList(statewideRegionalTechLayer);                
            }
            
        //});   
        })
        .fail(function() { arcgisErrorHandler("Legend error." ); });
        

        // Set another completion function for the request above
        //jsonCall.complete(function(data){ alert("second complete"); legendInfo = data.layers; return legendInfo; });
        
   }
}


function getLegend(mapServiceId,strLayerNum, legendInfo) {
    if (mapServiceId != "") {
        //var strDefDoc="Advisories_Definitions.pdf";
        var strLegendHTML="";
        //var legendInfo;
        var strMapServiceName="";
        if (mapServiceId ==="FishGen" ) {
            strMapServiceName=fishGenMSName;
            //legendInfo = legendInfoFishPop;
//        }else if (mapServiceId==="FishPollutants") {
//            strMapServiceName=fishPollMSName;
//            //legendInfo = legendInfoFishPoll;
//        }else if (mapServiceId==="FishSpecies") {
//            strMapServiceName=fishSpeciesMSName;
//            //legendInfo = legendInfoFishSpecies;
        }else if (mapServiceId ==="statewideRegionalLayer"){
            strMapServiceName=stateRegionalActiveMSName;           
        }else if (mapServiceId ==="statewideRegionalTechLayer"){
            strMapServiceName=stateRegionalTechMSName;           
        }else if (mapServiceId==="FishLayer") {
            //We use fishLayer for both tech and tissue sites so need to check which here
            if (strFishTechOrTissue==="ADV") {
                strMapServiceName=fishTechMSName;
            }else if (strFishTechOrTissue==="TISSUE"){
                strMapServiceName=fishTissueMSName;
                //strDefDoc="Fish_Tissue_Definitions.pdf";
//            }else if (strFishTechOrTissue="TISSUE_SUMMARY") {
//                strMapServiceName=fishTissueSummaryMSName;
            }
        }
        var strImageDir="//" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + strMapServiceName + "/MapServer/" + strLayerNum + "/images/";
        
        var strLabel="";
        
        for (var i in legendInfo) {
            if (legendInfo[i].layerId.toString()===strLayerNum.toString()) {
                for (var j in legendInfo[i].legend) {
                    strLabel=legendInfo[i].legend[j].label;
                    if (strLabel==="") {
                        strLabel=legendInfo[i].layerName;
                    }
                    //strLegendHTML = strLegendHTML + "<tr><td><img src='" + strImageDir + legendInfo[i].legend[j].url + "' class='legendImage' /></td><td><a href='docs/" + strDefDoc + "#" + strLabel + "' title='Show "+ strLabel + " Definition' target='_blank'>" + strLabel + "</a></td><tr>" ;
                    strLegendHTML = strLegendHTML + "<tr><td><img src='" + strImageDir + legendInfo[i].legend[j].url + "' class='legendImage' /></td><td>" + strLabel + "</td><tr>" ;
                }
                if (strLegendHTML != "")
                {
                    strLegendHTML = "<table class='legendTable'>" + strLegendHTML + "</table>";
                }
            }
        }       
        return strLegendHTML;      
    } else {
        return "No legend";
    }   
    
}

function addLegend(layers) {

   var layerInfo = [];        

    layerInfo=layers;       
    
    if(layerInfo.length > 0){                       
      legendDijit = new esri.dijit.Legend({
        map:map,
        layerInfos:layerInfo
      },"mapLegendDiv");
      legendDijit.startup();
    }
    else{
      dojo.byId('mapLegendDiv').innerHTML = 'No operational layers';
    }
}
  
function resizeMap() {
    //resize the map when the browser resizes - view the 'Resizing and repositioning the map' section in 
    //the following help topic for more details http://help.esri.com/EN/webapi/javascript/arcgis/help/jshelp_start.htm#jshelp/inside_guidelines.htm
    var resizeTimer;
    clearTimeout(resizeTimer);
    resizeTimer = setTimeout(function() {
      map.resize();
      map.reposition();
    }, 500);
}

function show_hide(tblid, show) {
    var tbl;
	if (tbl = dojo.byId(tblid)) {
		if (null == show) show = tbl.style.display == 'none';
		tbl.style.display = (show ? '' : 'none');
	}
}

function clear_sublayers(layerToClear){
    var inputs, input;
    
    inputs = dojo.query("." + layerToClear);    

    dojo.forEach(inputs,function(input){
      if (input.checked) {          
          input.checked=false;
      }
    });    

}

function SelectFirstLayer(tblid){
    //Make the 1st radio button in the Pollutants/Species sublayer list is checked
    // but only if none of them are already checked.
    var strClassName="";
    var boolAnyChecked=false;
    var inputs,input;
    var layerToClear;
    
	if (tblid.toString().search("Species") != -1) {
	   strClassName=".fish_species_list";
	   layerToClear="fish_pollutants_list";
    }else if (tblid.toString().search("Pollutants") != -1) {
       strClassName=".fish_pollutants_list";   
       layerToClear="fish_species_list";    
    }
    if (strClassName != "") {
       //check if there are other sublayer radio buttons already checked
       inputs = dojo.query(strClassName);
       dojo.forEach(inputs,function(input){
           if (input.checked) {
                boolAnyChecked = true;
           }           
       });
       //if no sublayer radio buttons are already checked then go ahead
       //and select the 1st radio button.
       if (boolAnyChecked === false) {  
           clear_sublayers(layerToClear);      
           inputs[0].checked=true;
           updateLayerVisibility();
       }
    }        
}

 
//function buildLayerList(layer) {
//    var fishPopLegendHTML ="";
//    var items = dojo.map(layer.layerInfos,function(info,index){
//        if (info.defaultVisibility) {                
//          visible.push(info.id);                          
//        }
//                      
//        
//        // If this is a Group Layer then add it to layer list (so only show 1 layer for points, lines, polygons)
//        if (info.parentLayerId === -1) {            
//            if (layer.id==="FishGen") {
//                    fishPopLegendHTML = getLegend(layer.id,info.subLayerIds[2], legendInfoFishPop);
//                    //alert (fishPopLegendHTML);
//                    //return "<input type='checkbox' class='fish_pop_list' checked='" + (info.defaultVisibility ? "checked" : "") + "' id='" + info.id + "' value='" + info.subLayerIds + "' onclick='updateLayerVisibility();' /><label for='" + info.id + "'>" + info.name + "</label><br>";
//                    return "<input type='radio' name='LayerRadio' checked class='fish_pop_list' id='" + info.id + "' value='" + info.subLayerIds + "' onclick='clear_sublayers(&quot;fish_pollutants_list&quot;); clear_sublayers(&quot;fish_species_list&quot;); show_hide(dojo.byId(&quot;FishPopDetailsDiv&quot;), true); show_hide(dojo.byId(&quot;FishPollutantsDetailsDiv&quot;), false); show_hide(dojo.byId(&quot;FishSpeciesDetailsDiv&quot;), false); updateLayerVisibility();' /><label for='" + info.id + "'>" + info.name + "</label>";
//               }else {
//                    var strClassName,strClearName,strLegendImage,legendInfo;
//                    if (layer.id==="FishPollutants") {
//                        strClassName="fish_pollutants_list";
//                        strClearName="fish_species_list"; 
//                        legendInfo=legendInfoFishPoll;                     
//                    }else {
//                        strClassName="fish_species_list";
//                        strClearName="fish_pollutants_list";
//                        legendInfo=legendInfoFishSpecies;
//                    }
//                    strLegendImage=getLegend(layer.id,info.subLayerIds[2],legendInfo);
//                    //return "<input type='radio' name='" + layer.id + "Radio' class='" + strClassName+ "' id='" + info.id + "' value='" + info.subLayerIds + "' onclick='updateLayerVisibility();' /><label for='" + info.id + "'>" + info.name + "</label><br>";
//                    return "<input type='radio' name='DetailLayersRadio' class='" + strClassName+ "' id='" + info.id + "' value='" + info.subLayerIds + "' onclick='clear_sublayers(&quot;" + strClearName + "&quot;); updateLayerVisibility();' />" + strLegendImage ; //"<label for='" + info.id + "'>" + info.name + "</label><br>";
//               }
//        }else {
//            return "";
//        }
//    });

//    var strFishSpeciesGroup;
//    var strTblName;
//    strTblName="&quot;FishSpeciesDetailsDiv&quot;";
//    //strFishSpeciesGroup="<a href='javascript:;' onclick='show_hide(" + strTblName + ")'>+/-</a>Fish Advisories by Species";
//    strFishSpeciesGroup="<input type='radio' name='LayerRadio' value='SpeciesLayer' onclick='show_hide(" + strTblName + ",true);show_hide(dojo.byId(&quot;FishPollutantsDetailsDiv&quot;), false); show_hide(dojo.byId(&quot;FishPopDetailsDiv&quot;), false); SelectFirstLayer(" + strTblName + ");'>Fish Advisories by Species";
//    
//    var strFishPollutantsGroup;
//    strTblName="&quot;FishPollutantsDetailsDiv&quot;";
//    //strFishPollutantsGroup="<a href='javascript:;' onclick='show_hide(" + strTblName + ")'>+/-</a>Fish Advisories by Pollutants";
//    strFishPollutantsGroup="<input type='radio' name='LayerRadio' value='PollutantsLayer' onclick='show_hide(" + strTblName + ",true);show_hide(dojo.byId(&quot;FishSpeciesDetailsDiv&quot;), false); show_hide(dojo.byId(&quot;FishPopDetailsDiv&quot;), false); SelectFirstLayer(" + strTblName + ");'>Fish Advisories by Pollutants";

//    
//    if (layer.id==="FishGen") {
//        dojo.byId("FishPopDetailsTitle").innerHTML = items.join(" ");        
//        dojo.byId("FishPopDetailsDiv").innerHTML = fishPopLegendHTML;
//    }else if (layer.id==="FishSpecies") {
//        dojo.byId("FishSpeciesDetailsTitle").innerHTML = strFishSpeciesGroup;
//        dojo.byId("FishSpeciesDetailsDiv").innerHTML = "<form name='VisibleSpeciesLayerForm'>" + items.join(" ") + "</form>";
//        show_hide(dojo.byId("FishSpeciesDetailsDiv"), false);
//    }else if (layer.id==="FishPollutants") {
//        dojo.byId("FishPollutantsDetailsTitle").innerHTML = strFishPollutantsGroup;
//        dojo.byId("FishPollutantsDetailsDiv").innerHTML = "<form name='VisiblePollutantsLayerForm'>" + items.join(" ") + "</form>";
//        show_hide(dojo.byId("FishPollutantsDetailsDiv"), false);
//    }

//    //layer.setVisibleLayers(visible);    
//    map.addLayer(layer);  
//    
//    //Add the featureLayers on top for selection
//    addSelectionFeatureLayers(fishGenMSName);      

//}

//This function is only used for General Site
function buildLayerList(layer){  
    var fishLegendHTML="";
    var items = dojo.map(layer.layerInfos, function(info,index)
    {
        
        if (info.defaultVisibility)
        {
            visible.push(info.id);                          
        }                              
        
        
        //if this is a Group Layer then add it to layer list (so only show 1 layer for points, lines, polygons)
        if (info.parentLayerId === -1)
        { 
            if (layer.id==="statewideRegionalLayer") {
                fishLegendHTML = getLegend(layer.id,info.id,legendInfoStatewides); 
                if (info.id===0) {
                    dojo.byId("RegionalDetailsDiv").innerHTML = fishLegendHTML; 
                    //return "<input type='checkbox' class='statewide_list' checked='" + (info.defaultVisibility ? "checked" : "") + "' id='" + info.id + "' value='" + info.id + "' onclick='updateSingleLayerVisiblity(&quot;.statewide_list&quot;,statewideRegionalLayer);' /><label for='" + info.id + "'><a href='docs/Advisories_Definitions.pdf#" + info.name + "' title='Show "+ info.name + " Definition' target='_blank'>" + info.name + "</a></label>";
                    return "<input type='checkbox' class='statewide_list' checked='" + (info.defaultVisibility ? "checked" : "") + "' id='" + info.id + "' value='" + info.id + "' onclick='updateSingleLayerVisiblity(&quot;.statewide_list&quot;,statewideRegionalLayer);' /><label for='" + info.id + "'>" + info.name + "</label>";
                }else if (info.id===1) {
                    dojo.byId("StatewideDetailsDiv").innerHTML = fishLegendHTML;
                    //return "<input type='checkbox' class='statewide_list' checked='" + (info.defaultVisibility ? "checked" : "") + "' id='" + info.id + "' value='" + info.id + "' onclick='updateSingleLayerVisiblity(&quot;.statewide_list&quot;,statewideRegionalLayer);' /><label for='" + info.id + "'><a href='docs/Advisories_Definitions.pdf#" + info.name + "' title='Show "+ info.name + " Definition' target='_blank'>" + info.name + "</a></label>";
                    return "<input type='checkbox' class='statewide_list' checked='" + (info.defaultVisibility ? "checked" : "") + "' id='" + info.id + "' value='" + info.id + "' onclick='updateSingleLayerVisiblity(&quot;.statewide_list&quot;,statewideRegionalLayer);' /><label for='" + info.id + "'>" + info.name + "</label>";
                }                 
                
            }else {
                //Only do the legend for the fish symbology layers - be sure to EXCLUDE the selection layers
                if (info.subLayerIds[2]<=6)  { 
                    fishLegendHTML = getLegend(layer.id,info.subLayerIds[2],legendInfoFishPop);            
                    dojo.byId("FishPopDetailsDiv").innerHTML = fishLegendHTML;
                    //return "<input type='checkbox' class='fish_list' checked='" + (info.defaultVisibility ? "checked" : "") + "' id='" + info.id + "' value='" + info.subLayerIds + "' onclick='updateSingleLayerVisiblity(&quot;.fish_list&quot;,FishGen);' /><label for='" + info.id + "'><a href='docs/Advisories_Definitions.pdf#" + info.name + "' title='Show "+ info.name + " Definition' target='_blank'>" + info.name + "</a></label>";
                    return "<input type='checkbox' class='fish_list' checked='" + (info.defaultVisibility ? "checked" : "") + "' id='" + info.id + "' value='" + info.subLayerIds + "' onclick='updateSingleLayerVisiblity(&quot;.fish_list&quot;,FishGen);' /><label for='" + info.id + "'>" + info.name + "</label>";
                }
            }
        }
        else
        {
            return "";
        }
    });

    if (layer.id==="statewideRegionalLayer") {
        dojo.byId("RegionalDetailsTitle").innerHTML = items[0];
        dojo.byId("StatewideDetailsTitle").innerHTML = items[1];
    }else{
        var strSelectionCheckbox="<input type='checkbox' class='selection_list' checked='true' id='SelectedSetCheckbox' onclick='updateSelectedSetVisiblity();'/>";
        dojo.byId("FishPopDetailsTitle").innerHTML = items.join(" ");
        //dojo.byId("SelectedDetailsTitle").innerHTML = "<table class='legendTable'><tr><td class='checkbox'>" + strSelectionCheckbox + "</td><td><img src='images/selectedColor.png' class='legendImage' /></td><td><a href='docs/Advisories_Definitions.pdf#Advisories Matching Search' title='Show Advisories Matching Search Definition' target='_blank'>Indicates advisories that match your search results</a></td></tr></table>";
        //dojo.byId("IdentifyDetailsTitle").innerHTML = "<table class='legendTable'><tr><td><img src='images/identifyColor.png' class='legendImage' /></td><td><a href='docs/Advisories_Definitions.pdf#Selected Advisory' title='Show Selected Advisory Definition' target='_blank'>Indicates an Advisory that you clicked on</a></td></tr></table>";
        dojo.byId("SelectedDetailsTitle").innerHTML = "<table class='legendTable'><tr><td class='checkbox'>" + strSelectionCheckbox + "</td><td><img src='images/selectedColor.png' class='legendImage' /></td><td>Indicates advisories that match your search results</td></tr></table>";
        dojo.byId("IdentifyDetailsTitle").innerHTML = "<table class='legendTable'><tr><td><img src='images/identifyColor.png' class='legendImage' /></td><td>Indicates an Advisory that you clicked on</td></tr></table>";

    }
        
    map.addLayer(layer);  
    
    //Add the featureLayers on top for selection
    if (layer === FishGen) {
    
        if ((fLayerPoints===null) || (fLayerLines === null) || (fLayerPolygons===null) || (fLayerPoints===undefined) || (fLayerLines === undefined) || (fLayerPolygons===undefined)) {
            addSelectionFeatureLayers(fishGenMSName);
        }
        if (boolNewQuery){
            selectWaterbody();
        }     
    }
}

function updateSelectedSetVisiblity() {
    inputs = dojo.query(".selection_list");

    dojo.forEach(inputs,function(input){
        if (input.checked) {
            fLayerPoints.show();
            fLayerLines.show();
            fLayerPolygons.show();
        }else {
            fLayerPoints.hide();
            fLayerLines.hide();
            fLayerPolygons.hide();
        }
        
      });      

}

function updateSingleLayerVisiblity(strListID,theLayer) {
    var inputs, input;   
    var identifyLayer="";
    var arrayLayerIDs=[];  
    var visibleLayer="";   
    var strLayerNum;
    
    inputs = dojo.query(strListID);

    var layerVisibleArray = [];

    dojo.forEach(inputs,function(input){
      if (input.checked) {
          
          layerVisibleArray.push(input.value);
          
          //Set which subayers to identify on.
          if (layerVisibleArray[0]==="1,2,3,4,5,6") {
            arrayLayerIDs = [1,2,3];
          }else {
            arrayLayerIDs = layerVisibleArray[0].split(",");
          }
          visibleLayer=theLayer.id;
      }
      });
    
    //Check for the statewide layer b/c have to explictly turn on/off the border layer since it's as separate map service
     if (strListID===".statewide_list") {
        statewideBorder.hide();
        dojo.forEach(layerVisibleArray,function(x){ 
            if (x === "1") {
                statewideBorder.show();          
            } 
        }); 
     }
    //if there aren't any layers visible set the array to be -1      
    if(layerVisibleArray.length === 0){
      layerVisibleArray.push(-1);         
    }else {
        //Set which Layer to identify on and which sublayers.
        identifyLayer=theLayer.url;
        
        //if (strFishTechOrTissue==="TISSUE") {
        if (layerVisibleArray[0]==="1,2,3,4,5,6") {
             var visibleArray = [1,2,3];
        }else {
            var visibleArray=layerVisibleArray[0].split(",");
        }
        strLayerNum=visibleArray[2];
    }   
    
    //Update the initialization for the Identify b/c now will Identify on a different layer.
//    if (identifyLayer!="") {
//        updateIdentifyLayer(identifyLayer,arrayLayerIDs);
//    }
    
    getLegend(visibleLayer,strLayerNum);
    
    //Now set all the layers we really want visible since we just made the legend.
    theLayer.setVisibleLayers(layerVisibleArray );
    
}

function updateLayerVisibility() {      
    
    //clear the identify window and any graphics since the user changed the layer.
    map.infoWindow.hide();
    map.graphics.clear();
          
    //For the FISH_POP layer
    updateSingleLayerVisiblity(".fish_pop_list", FishGen);    
    
    //For the FISH_POLLUTANTS layer
    updateSingleLayerVisiblity(".fish_pollutants_list", FishPollutants);    
    
    //For the FISH_SPECIES layer
    updateSingleLayerVisiblity(".fish_species_list", FishSpecies);
    
    
}

function setupAjax() {
    $.ajaxSetup({async: false, type: "POST", dataType: "json", timeout: 50000 });
}

function loadFishLayers(){
    //Add Fish Layer
    var imageParameters = new esri.layers.ImageParameters();
    imageParameters.layerIds = [0];
    imageParameters.layerOption = esri.layers.ImageParameters.LAYER_OPTION_SHOW;
    FishGen = new esri.layers.ArcGISDynamicMapServiceLayer("//" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + fishGenMSName + "/MapServer",{"imageParameters":imageParameters});    
    FishGen.id="FishGen";
    FishGen.setVisibleLayers([1,2,3,4,5,6]);
    legendLayers.push({layer:FishGen,title:'Active Fish Advisories'});  
    
    //Update the layer definition of the fish layers
    var st = dojo.byId("ctl00_cpContent_pnlMap_StateSelected").value;
    var layerDefinitions = [];
    layerDefinitions[1] = stFieldName + "='" + st + "'";
    layerDefinitions[2] = stFieldName + "='" + st + "'";
    layerDefinitions[3] = stFieldName + "='" + st + "'";
    layerDefinitions[4] = stFieldName + "='" + st + "'";
    layerDefinitions[5] = stFieldName + "='" + st + "'";
    layerDefinitions[6] = stFieldName + "='" + st + "'";
    FishGen.setLayerDefinitions(layerDefinitions);  
    
    //Build Layer List - Fish Layers
    if (FishGen.loaded) {
//      buildLayerList(FishGen);
//      //addSelectionFeatureLayers(fishPopMSName); 
        storeLegendInfo(serverName,fishMSFolder+ "/" + fishGenMSName);    
    }
    else {
//      dojo.connect(FishGen, "onLoad", function() { buildLayerList(FishGen);}); //addSelectionFeatureLayers(fishPopMSName);});      
        dojo.connect(FishGen, "onLoad", function() { 
            storeLegendInfo(serverName,fishMSFolder+ "/" + fishGenMSName); 
        });
    } 
    
//    //Make sure order of layers is correct w/ fish advisories on top
//    dojo.connect(map, "onLayerAdd", function(layer) { 
//        if (layer===FishGen) {
//            selectWaterbody(); 
//        } 
//        if (layer===statewideRegionalLayer) {
//            map.reorderLayer(statewideRegionalLayer,1);
//        } 
//    });   
    
    boolFishLoaded=true;
    
    //initialize identify layer 
    var identifyLayer="//" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + fishGenMSName + "/MapServer";
    initIdentifyFunctionality(map,identifyLayer,[1,2,3]);
    
}

function initFishMap(evt,st) {
    
    //Show loading ...
    esri.show(dojo.byId("mapStatus")); 
    
    //setup some defaults for ajax
    setupAjax();
    
    //identify proxy page to use if the toJson payload to the geometry service is greater than 2000 characters.
    //If this null or not available the buffer operation will not work.  Otherwise it will do a http post to the proxy.
    esriConfig.defaults.io.proxyUrl = proxyURL;
    esriConfig.defaults.io.alwaysUseProxy = false;
    
    //re-adjust the size of the window back to the larger/scalable size
    adjustMapWin();      
    
    //Set global that we are working with advisory data not fish tissue
    strFishTechOrTissue="ADV";
    boolGeneralSite=true;
    
    //Variable for advisory number hidden var name - it's in a different panel in General site than tissue and tech
    strAdvNumHiddenVarName="ctl00_cpContent_pnlMap_AdvisoryNumber";
    
    //Delete all the inset divs
    deleteInsetWins();
    
    //Show the legend/layer list
    esri.show(dojo.byId("LayerVisibleDiv"));     

//    //Set the title, etc
//    dojo.byId("mapTitle").innerHTML = title || "";    
//    dojo.byId("mapOwner").innerHTML = owner || "";
//    
    //var initExtent = new esri.geometry.Extent({"xmin":-13900000,"ymin":2480000,"xmax":-7450000,"ymax":5430000,"spatialReference":{"wkid":102100}});
    initExtent = new esri.geometry.Extent({"xmin":-16591000,"ymin":2218000,"xmax":-5672000,"ymax":6572000,"spatialReference":{"wkid":102100}});       
    stateExtent=selectExtent;
    map = new esri.Map("map",{wrapAround180:true, extent:selectExtent, logo:false}); 
                         
    map.enableMapNavigation(); 
    map.showZoomSlider();

    //Identify initialization
//    var identifyLayer="http://" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + fishGenMSName + "/MapServer";
    statewideIdentifyLayer="//" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + stateRegionalActiveMSName + "/MapServer";
//    statewideIdentifyLayer="http://" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + advWhereULiveMSName + "/MapServer";

   // dojo.connect(map, "onLoad", initIdentifyFunctionality(map,identifyLayer,[1,2,3]));
    //Listen for infoWindow onHide event
    dojo.connect(map.infoWindow, "onHide", function() {
        map.graphics.clear(); 
        numIdentifyPopUpCounter=0;
        textShow=""; 
        boolFedText=false;       
        if (dojo.byId(strAdvNumHiddenVarName)) { 
            dojo.byId(strAdvNumHiddenVarName).value="";
        }
    });

    //Add base layers to the map
    addBaseLayers();

    //Add Statewides and Regionals Layers
    var imageParameters2 = new esri.layers.ImageParameters();
    imageParameters2.layerIds = [0,1];
    imageParameters2.layerOption = esri.layers.ImageParameters.LAYER_OPTION_SHOW;
    statewideRegionalLayer = new esri.layers.ArcGISDynamicMapServiceLayer("//" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + stateRegionalActiveMSName + "/MapServer",{"imageParameters":imageParameters2});    
    statewideRegionalLayer.id="statewideRegionalLayer";
    statewideRegionalLayer.setVisibleLayers([0,1]);
    statewideRegionalLayer.setOpacity(0.6);
    legendLayers.push({layer:statewideRegionalLayer,title:'Active Statewide and Regional Advisories'});
    
    statewideBorder = new esri.layers.ArcGISDynamicMapServiceLayer("//" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + stateRegionalActiveMSName + "/MapServer",{"imageParameters":imageParameters2});    
    statewideBorder.setVisibleLayers([2]);       
    
    //Update the layer definition of the statewide/regional layers so nothing is on until the user
    //selects a state
    var layerDefinitions = [];
    layerDefinitions[0] = "ST=''";
    layerDefinitions[1] = "ST=''";
    layerDefinitions[2] = "ST=''";
    statewideRegionalLayer.setLayerDefinitions(layerDefinitions);
    statewideBorder.setLayerDefinitions(layerDefinitions); 
    
    //Add Fish Layer
//    var imageParameters = new esri.layers.ImageParameters();
//    imageParameters.layerIds = [0];
//    imageParameters.layerOption = esri.layers.ImageParameters.LAYER_OPTION_SHOW;
//    FishGen = new esri.layers.ArcGISDynamicMapServiceLayer("http://" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + fishGenMSName + "/MapServer",{"imageParameters":imageParameters});    
//    FishGen.id="FishGen";
//    FishGen.setVisibleLayers([1,2,3]);
//    legendLayers.push({layer:FishGen,title:'Active Fish Advisories'});
    
    
    //Get the initExtent for the map based on the state the user clicked
    if (evt != null) {         
        dojo.connect(map, "onLoad", function(){            
            //Add Scalebar
            var scalebar = new esri.dijit.Scalebar({map: map,scalebarUnit:"english"});                            
        });
        GetStateSelected(evt,st);
    }else{
        //If the user did not click the map but used the dropdowns then we'll want to just zoom it now      
        //Hidden variable should be set, so zoom to the state
        var st = dojo.byId("ctl00_cpContent_pnlMap_StateSelected").value;
        dojo.connect(map, "onLoad", function(){
            //Add Scalebar
            var scalebar = new esri.dijit.Scalebar({map: map,scalebarUnit:"english"}); 
            getStateExtent(st,true,false);               
        });
    }
    
     
    
    //Add identify
    dojo.connect(map.infoWindow, "onShow", function() {
       esri.show(dojo.byId("idResultsBorder"));
       dijit.byId("idResultsBorder").resize();
    });
    
    //Add the fish layers as selection layers on top
    zoomExtent = initExtent;
    
    //Build Layer List - Statewides/Regionals Layers
    if (statewideRegionalLayer.loaded) {
//      buildLayerList(statewideRegionalLayer);
//      //addSelectionFeatureLayers(fishPopMSName); 
        storeLegendInfo(serverName,fishMSFolder+ "/" + stateRegionalActiveMSName);    
    }
    else {
//      dojo.connect(statewideRegionalLayer, "onLoad", function() { buildLayerList(statewideRegionalLayer);}); //addSelectionFeatureLayers(fishPopMSName);});      
      dojo.connect(statewideRegionalLayer, "onLoad", function() {  storeLegendInfo(serverName,fishMSFolder+ "/" + stateRegionalActiveMSName); });
    }
    
    if (statewideBorder.loaded) {
        map.addLayer(statewideBorder);    
    }
    else {
      dojo.connect(statewideBorder, "onLoad", function() {  map.addLayer(statewideBorder); });
    }
    //Make sure order of layers is correct w/ fish advisories on top
    dojo.connect(map, "onLayerAdd", function(layer) { if (layer===statewideRegionalLayer) {map.reorderLayer(statewideRegionalLayer,2);} if (layer===statewideBorder) {map.reorderLayer(statewideBorder,3);} });   

    
//    //Build Layer List - Fish Layers
//    if (FishGen.loaded) {
////      buildLayerList(FishGen);
////      //addSelectionFeatureLayers(fishPopMSName); 
//        storeLegendInfo(serverName,fishMSFolder+ "/" + fishGenMSName);    
//    }
//    else {
////      dojo.connect(FishGen, "onLoad", function() { buildLayerList(FishGen);}); //addSelectionFeatureLayers(fishPopMSName);});      
//        dojo.connect(FishGen, "onLoad", function() { storeLegendInfo(serverName,fishMSFolder+ "/" + fishGenMSName); });
//    } 
//    
//    //Make sure order of layers is correct w/ fish advisories on top
//    dojo.connect(map, "onLayerAdd", function(layer) { if (layer===statewideRegionalLayer) {map.reorderLayer(statewideRegionalLayer,1);} });

    //Prevent zooming in too far on basemaps
    dojo.connect(map, "onZoomEnd", function(extent, zoomFactor, anchor, level) { 
        var minLevel=streetLayer.tileInfo.lods.length-1;
        if (level>=minLevel) {
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
    
    //esri.hide(dojo.byId("mapStatus"));
    
//    if (FishSpecies.loaded) {
//      buildLayerList(FishSpecies);
//    }
//    else {
//      dojo.connect(FishSpecies, "onLoad", buildLayerList);
//    }
//    
//    if (FishPollutants.loaded) {
//      buildLayerList(FishPollutants);
//    }
//    else {
//      dojo.connect(FishPollutants, "onLoad", buildLayerList);
//    }  
//    
    //esri.hide("status");
    
    //This builds a multi-dimensional array to hold the data in the
    //ACTIVE_ADVISORIES view (advnum,advisory name for all advisories in the Population layer)
    //dojo.connect(map, "onLoad", getWbNamesList());
             
    
    //Do this to update legend to only show polygons.
    //Had to do it this on each extent change b/c the legend is built on the layers shown on the map.
    //I have no way of knowing the scale and whether the layer is actually shown
    // - it is considered visible even though the scale won't allow it to show.
    // 5/11/11 backed out this code b/c no longer have to fool the legend widget b/c
    // now capturing JSON response from Legend service and making my own legend.
//    dojo.connect(map, "onExtentChange", function(extent){
//           updateLayerVisibility();  
//    });


      
    //resize the map when the browser resizes - view the 'Resizing and repositioning the map' section in 
    //the following help topic for more details http://help.esri.com/EN/webapi/javascript/arcgis/help/jshelp_start.htm#jshelp/inside_guidelines.htm
    var resizeTimer;
    dojo.connect(map, 'onLoad', function(theMap) {
      dojo.connect(dijit.byId('map'), 'resize', function() {  //resize the map if the div is resized
        clearTimeout(resizeTimer);
        resizeTimer = setTimeout( function() {
          map.resize();
          map.reposition();
        }, 500);
      });
    });        
}

function deleteInsetWins()
{
    if (clickMap != null)
    {
        clickMap.removeAllLayers();
    }
    document.getElementById('clickMap').style.display = 'none';
    if (AKmap != null)
    {
        AKmap.removeAllLayers();
    }
    document.getElementById('insetWinAK').style.display='none';
    if (HImap != null)
    {
        HImap.removeAllLayers();
    }
    document.getElementById('insetWinHI').style.display='none';
    if (Guammap != null)
    {
        Guammap.removeAllLayers();
    }
    document.getElementById('insetWinGuam').style.display='none';
    if (ASmap != null)
    {
        ASmap.removeAllLayers();
    }
    document.getElementById('insetWinAS').style.display='none';
    if (PRmap != null)
    {
        PRmap.removeAllLayers();
    }
    document.getElementById('insetWinPR').style.display='none';
    if (VImap != null)
    {
        VImap.removeAllLayers();
    }
    document.getElementById('insetWinVI').style.display='none';
    if (NEmap != null)
    {
        NEmap.removeAllLayers();
    }
    document.getElementById('insetWinNE').style.display='none';
}

function hideDivs()
{
    esri.hide(dojo.byId("LayerVisibleDiv")); 
    esri.hide(dojo.byId("idResultsBorder"));  
    esri.hide(dojo.byId("mapStatus"));
    esri.hide(dojo.byId("waterbodyPopUpDiv"));
}

function resetMapItems()
{
    try
    {
        map.infoWindow.hide();
        map.graphics.clear();
    }
    catch (ex)
    {
        //'map.infoWindow' and 'map.graphics' will throw errors if they haven't been defined yet
        //this will bypass the errors
    }
    var wbPopUpDiv = dojo.byId("waterbodyPopUpDiv");
    if (wbPopUpDiv)
    {
        esri.hide(dojo.byId("waterbodyPopUpDiv"));
    }
    var infoBorderDiv = dojo.byId("infoBorderDiv");
    if (infoBorderDiv)
    {
        esri.hide(dojo.byId("infoBorderDiv"));
    }
}

function getStAbbrev(evt, map, showPopUp)
{
    
    var stIDParams = new esri.tasks.IdentifyParameters();
    stIDParams.tolerance = 3;
    stIDParams.returnGeometry = false;
    stIDParams.layerOption =esri.layers.ImageParameters.LAYER_OPTION_SHOW;
    stIDParams.width  = map.width;
    stIDParams.height = map.height;
    
    stIDParams.geometry = evt.mapPoint;
    stIDParams.mapExtent = map.extent;
    
    var identifyTaskSt = new esri.tasks.IdentifyTask("//" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + advWhereULiveMSName + "/MapServer");

    identifyTaskSt.execute(stIDParams, function(res)
    {
        if (res.length > 0)
        {
            if (showPopUp)
            {
                map.infoWindow.setContent(res[0].feature.attributes["ST"]);
                map.infoWindow.show(evt.screenPoint, map.getInfoWindowAnchor(evt.screenPoint));
            }
            else
            {
                setHiddenStateVar(res[0].feature.attributes["ST"]);

                //update hidden field to flag that second map is loaded
                dojo.byId("ctl00_cpContent_pnlMap_hfMapLoaded").value = "2";
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
        else
        {
            map.infoWindow.hide();
            if (showPopUp === false)
            {
                esri.hide(dojo.byId("mapStatus"));
                alert("No state found.  Please choose a state from the dropdown list on the left.");
            }
        }
    }, function(error) { arcgisErrorHandler(error);});
}

function initAdvisoriesWhereYouLive()
{   
    //setup some defaults for ajax
    setupAjax(); 
    
    //identify proxy page to use if the toJson payload to the geometry service is greater than 2000 characters.
    //If this null or not available the buffer operation will not work.  Otherwise it will do a http post to the proxy.
    esriConfig.defaults.io.proxyUrl = proxyURL;
    esriConfig.defaults.io.alwaysUseProxy = false;
    
    strFishTechOrTissue="ADV";

    hideDivs();

   //Set the title, etc
    //dojo.byId("mapTitle").innerHTML = title || "";    
    //dojo.byId("mapOwner").innerHTML = owner || "";
     	 	 	         	 	 	
    //Continental US
    //var clickableMS = new esri.layers.ArcGISDynamicMapServiceLayer("http://" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + advWhereULiveMSName + "/MapServer");    
    var contUS = new esri.layers.ArcGISDynamicMapServiceLayer("//" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + advWhereULiveMSName + "/MapServer");            
    //var contUSLabels = new esri.layers.ArcGISDynamicMapServiceLayer("http://" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + advWhereULiveMSName + "/MapServer");            

    //Setup popup for ST abbreviation as user moves mouse
    var USInfoWindow = new myModules.InfoWindow({ 
      domNode: dojo.create("infoBorderDiv", null, dojo.byId("clickMap")) 
    });
    
    clickMap = new esri.Map("clickMap",{extent:contUSExtent, infoWindow:USInfoWindow, logo:false});       
    contUS.setVisibleLayers([0]); 
//    contUS.setOpacity(0.5);
//    contUSLabels.setVisibleLayers([8]);
//    contUSLabels.setOpacity(1);
    
    //hide the buttons to switch between base layers when the clickable map is shown
    btnStreetMap.SetVisible(false);
    btnImageryMap.SetVisible(false);
    
    //Add the ESRI street map layer to the map
    var basemap = new esri.layers.ArcGISTiledMapServiceLayer(streetLayerURL);

    //Add the Bing street map layer to the map
    //var basemap = new esri.virtualearth.VETiledLayer(
    //{
    //    bingMapsKey: esriBingMapsKey,
    //    mapStyle: esri.virtualearth.VETiledLayer.MAP_STYLE_ROAD
    //});
    
    clickMap.addLayer(basemap);
    
    //alert("width: " + clickMap.width + " height: " + clickMap.height + " ratio w/h:" + clickMap.width / clickMap.height);
    
    //Setup popup for ST abbreviation as user moves mouse
    //Listen for infoWindow onHide event
    dojo.connect(clickMap.infoWindow, "onHide", function() { clickMap.infoWindow.setContent(""); clickMap.graphics.clear();});
    //onMouseMove show the state abbreviation as popup
//    dojo.connect(clickMap, "onMouseMove", function(evt){                
//        getStAbbrev(evt, clickMap, true);        
//    });
//    //hide the popup when the user moves outside the map inset
//    dojo.connect(clickMap, "onMouseOut", function(evt){                
//        clickMap.infoWindow.hide();
//    });
    
    //turn off all zooms/pans - this has to happen in the onLoad function of the map
    dojo.connect(clickMap, "onLoad", function() { 
        //alert("TEST - width=" + clickMap.width.toString());
        if (clickMap.width > 1381) {
            clickMap.setLevel(5);
        }else {
            clickMap.setLevel(4);
        } 
        clickMap.disableMapNavigation(); 
        clickMap.hideZoomSlider(); 
    }); //document.getElementById('LayerVisibleDiv').style.display='none';  document.getElementById('idResultsBorder').style.display='none'; document.getElementById('mapStatus').style.display='none'; });    
    
    //When the user clicks a state we want to open the app and let them choose a waterbody.
    dojo.connect(clickMap, "onClick", function(evt){ initFishMap(evt,"US"); }); 
    
    //Make sure order of layers is correct w/ state boundary on top
    dojo.connect(clickMap, "onLayerAdd", function(layer) { if (layer===contUS) {clickMap.reorderLayer(contUS,1);} });
        
    //add the layer now
    //clickMap.addLayer(contUS);
    
    if (contUS.loaded) {
        clickMap.addLayer(contUS);    
    }
    else {
        dojo.connect(contUS, "onLoad", function() { 
            clickMap.addLayer(contUS); 
        });
    } 
        
//    if (contUSLabels.loaded) {
//        clickMap.addLayer(contUSLabels);    
//    }
//    else {
//        dojo.connect(contUSLabels, "onLoad", function() { 
//            clickMap.addLayer(contUSLabels); 
//        });
//    }
//    dojo.connect(clickMap, "onLayerAdd", function(layer) { if (layer===contUS) {clickMap.reorderLayer(contUS,1);} });
    
    //****************************
    //Alaska       
    var AKLayer = new esri.layers.ArcGISDynamicMapServiceLayer("//" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + advWhereULiveMSName + "/MapServer");    
    //var AKLayer = new esri.layers.ArcGISTiledMapServiceLayer(basemapLayerURL);
    //var AKLayer = new esri.layers.FeatureLayer("http://" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + advWhereULiveMSName + "/MapServer/5", {mode: esri.layers.FeatureLayer.MODE_SNAPSHOT, outFields: ["*"]});
    
    //Setup popup for ST abbreviation as user moves mouse
    var AKInfoWindow = new myModules.InfoWindow({ 
      domNode: dojo.create("infoBorderDiv", null, dojo.byId("AKmap")) 
    }); 
    
    AKmap = new esri.Map("AKmap",{extent:AKExtent, infoWindow:AKInfoWindow, logo:false});    
    AKLayer.setVisibleLayers([5]);
       

    //Setup popup for ST abbreviation as user moves mouse
    //Listen for infoWindow onHide event
    dojo.connect(AKmap.infoWindow, "onHide", function() {AKmap.graphics.clear();});
    //onMouseMove show the state abbreviation as popup
//    dojo.connect(AKmap, "onMouseMove", function(evt){                
//        //dijit.byId("info").setContent("AK");
//        clickMap.infoWindow.hide();
//        AKmap.infoWindow.setContent("AK");
//        AKmap.infoWindow.show(evt.screenPoint, AKmap.getInfoWindowAnchor(evt.screenPoint));
//    });
//    //hide the popup when the user moves outside the map inset
//    dojo.connect(AKmap, "onMouseOut", function(evt){                
//        AKmap.infoWindow.hide();
//    });
    
    //turn off all zooms/pans - this has to happen in the onLoad function of the map
    dojo.connect(AKmap, "onLoad", function() { AKmap.disableMapNavigation(); AKmap.hideZoomSlider(); hideDivs();  });    
    
    //When the user clicks a state we want to open the app and let them choose a waterbody.
    dojo.connect(AKmap, "onClick", function(evt){ initFishMap(evt,"AK"); }); 
    
    //add the layer now
    AKmap.addLayer(AKLayer); 
    
        
    //****************************
    //Hawaii
    var HILayer = new esri.layers.ArcGISDynamicMapServiceLayer("//" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + advWhereULiveMSName + "/MapServer");    
    
    //Setup popup for ST abbreviation as user moves mouse
    var HIInfoWindow = new myModules.InfoWindow({ 
      domNode: dojo.create("infoBorderDiv", null, dojo.byId("HImap")) 
    });

    HImap = new esri.Map("HImap",{extent:HIExtent, infoWindow:HIInfoWindow, logo:false});
    HILayer.setVisibleLayers([4]); 
    
    //Setup popup for ST abbreviation as user moves mouse
    //Listen for infoWindow onHide event
    dojo.connect(HImap.infoWindow, "onHide", function() {HImap.graphics.clear();});
    //onMouseMove show the state abbreviation as popup
//    dojo.connect(HImap, "onMouseMove", function(evt){  
//        clickMap.infoWindow.hide();              
//        HImap.infoWindow.setContent("HI");
//        HImap.infoWindow.show(evt.screenPoint, HImap.getInfoWindowAnchor(evt.screenPoint));
//    });
//    //hide the popup when the user moves outside the map inset
//    dojo.connect(HImap, "onMouseOut", function(evt){                
//        HImap.infoWindow.hide();
//    });
       
    //turn off all zooms/pans - this has to happen in the onLoad function of the map
    dojo.connect(HImap, "onLoad", function() { HImap.disableMapNavigation(); HImap.hideZoomSlider(); });    
    
    //When the user clicks a state we want to open the app and let them choose a waterbody.
    dojo.connect(HImap, "onClick", function(evt){ initFishMap(evt,"HI");  }); 
    
    //add the layer now
    HImap.addLayer(HILayer); 
    
    //****************************
    //American Samoa
    var ASLayer = new esri.layers.ArcGISDynamicMapServiceLayer("//" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + advWhereULiveMSName + "/MapServer");    
    
    //Setup popup for ST abbreviation as user moves mouse
    var ASInfoWindow = new myModules.InfoWindow({ 
      domNode: dojo.create("infoBorderDiv", null, dojo.byId("ASmap")) 
    });
    
    ASmap = new esri.Map("ASmap",{extent:ASExtent, infoWindow:ASInfoWindow, logo:false});    
    ASLayer.setVisibleLayers([3]);
    
    //Setup popup for ST abbreviation as user moves mouse
    //Listen for infoWindow onHide event
    dojo.connect(ASmap.infoWindow, "onHide", function() {ASmap.graphics.clear();});
    //onMouseMove show the state abbreviation as popup
//    dojo.connect(ASmap, "onMouseMove", function(evt){                
//        clickMap.infoWindow.hide();
//        ASmap.infoWindow.setContent("AS");
//        ASmap.infoWindow.show(evt.screenPoint, ASmap.getInfoWindowAnchor(evt.screenPoint));
//    });
//    //hide the popup when the user moves outside the map inset
//    dojo.connect(ASmap, "onMouseOut", function(evt){                
//        ASmap.infoWindow.hide();
//    });
    
    //turn off all zooms/pans - this has to happen in the onLoad function of the map
    dojo.connect(ASmap, "onLoad", function() { ASmap.disableMapNavigation(); ASmap.hideZoomSlider(); });    
    
    //When the user clicks a state we want to open the app and let them choose a waterbody.
    dojo.connect(ASmap, "onClick", function(evt){ initFishMap(evt,"AS");  }); 
    
    //add the layer now
    ASmap.addLayer(ASLayer); 
    
    //************************
     //Guam
    var GuamLayer = new esri.layers.ArcGISDynamicMapServiceLayer("//" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + advWhereULiveMSName + "/MapServer");    
    
    //Setup popup for ST abbreviation as user moves mouse
    var GuamInfoWindow = new myModules.InfoWindow({ 
      domNode: dojo.create("infoBorderDiv", null, dojo.byId("Guammap")) 
    });
    
    Guammap = new esri.Map("Guammap",{extent:GuamExtent, infoWindow:GuamInfoWindow, logo:false});    
    GuamLayer.setVisibleLayers([1]);
    
    //Setup popup for ST abbreviation as user moves mouse
    //Listen for infoWindow onHide event
    dojo.connect(Guammap.infoWindow, "onHide", function() {Guammap.graphics.clear();});
    //onMouseMove show the state abbreviation as popup
//    dojo.connect(Guammap, "onMouseMove", function(evt){                
//        //dijit.byId("info").setContent("AK");
//        clickMap.infoWindow.hide();
//        Guammap.infoWindow.setContent("GUAM");
//        Guammap.infoWindow.show(evt.screenPoint, Guammap.getInfoWindowAnchor(evt.screenPoint));
//    });
//    //hide the popup when the user moves outside the map inset
//    dojo.connect(Guammap, "onMouseOut", function(evt){                
//        Guammap.infoWindow.hide();
//    });
    
    //turn off all zooms/pans - this has to happen in the onLoad function of the map
    dojo.connect(Guammap, "onLoad", function() { Guammap.disableMapNavigation();Guammap.hideZoomSlider(); });    
    
    //When the user clicks a state we want to open the app and let them choose a waterbody.
    dojo.connect(Guammap, "onClick", function(evt){ initFishMap(evt,"GU");  }); 
    
    //add the layer now
    Guammap.addLayer(GuamLayer); 
    
    
    //**********************
    //Puerto Rico
    var PRLayer = new esri.layers.ArcGISDynamicMapServiceLayer("//" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + advWhereULiveMSName + "/MapServer");    
    
    //Setup popup for ST abbreviation as user moves mouse
    var PRInfoWindow = new myModules.InfoWindow({ 
      domNode: dojo.create("infoBorderDiv", null, dojo.byId("PRmap")) 
    });
    
    PRmap = new esri.Map("PRmap",{extent:PRExtent, infoWindow:PRInfoWindow, logo:false});    
    PRLayer.setVisibleLayers([6]);
    
    //Setup popup for ST abbreviation as user moves mouse
    //Listen for infoWindow onHide event
    dojo.connect(PRmap.infoWindow, "onHide", function() {PRmap.graphics.clear();});
    //onMouseMove show the state abbreviation as popup
//    dojo.connect(PRmap, "onMouseMove", function(evt){                
//        //dijit.byId("info").setContent("AK");
//        clickMap.infoWindow.hide();
//        PRmap.infoWindow.setContent("PR");
//        PRmap.infoWindow.show(evt.screenPoint, PRmap.getInfoWindowAnchor(evt.screenPoint));
//    });
//    //hide the popup when the user moves outside the map inset
//    dojo.connect(PRmap, "onMouseOut", function(evt){                
//        PRmap.infoWindow.hide();
//    });
    
    //turn off all zooms/pans - this has to happen in the onLoad function of the map
    dojo.connect(PRmap, "onLoad", function() { PRmap.disableMapNavigation(); PRmap.hideZoomSlider(); });    
    
    //When the user clicks a state we want to open the app and let them choose a waterbody.
    dojo.connect(PRmap, "onClick", function(evt){ initFishMap(evt,"PR");  }); 
    
    //add the layer now
    PRmap.addLayer(PRLayer);
    
    //*******************************
    //Virgin Islands
    var VILayer = new esri.layers.ArcGISDynamicMapServiceLayer("//" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + advWhereULiveMSName + "/MapServer");    
    
    //Setup popup for ST abbreviation as user moves mouse
    var VIInfoWindow = new myModules.InfoWindow({ 
      domNode: dojo.create("infoBorderDiv", null, dojo.byId("VImap")) 
    });
    
    VImap = new esri.Map("VImap",{extent:VIExtent, infoWindow:VIInfoWindow, logo:false});    
    VILayer.setVisibleLayers([2]);
    
    //Setup popup for ST abbreviation as user moves mouse
    //Listen for infoWindow onHide event
    dojo.connect(VImap.infoWindow, "onHide", function() {VImap.graphics.clear();});
    //onMouseMove show the state abbreviation as popup
//    dojo.connect(VImap, "onMouseMove", function(evt){                
//        //dijit.byId("info").setContent("AK");
//        clickMap.infoWindow.hide();
//        VImap.infoWindow.setContent("VI");
//        VImap.infoWindow.show(evt.screenPoint, VImap.getInfoWindowAnchor(evt.screenPoint));
//    });
//    //hide the popup when the user moves outside the map inset
//    dojo.connect(VImap, "onMouseOut", function(evt){                
//        VImap.infoWindow.hide();
//    });
    
    
    //turn off all zooms/pans - this has to happen in the onLoad function of the map
    dojo.connect(VImap, "onLoad", function() { VImap.disableMapNavigation(); VImap.hideZoomSlider(); });    
    
    //When the user clicks a state we want to open the app and let them choose a waterbody.
    dojo.connect(VImap, "onClick", function(evt){ initFishMap(evt,"VI");  }); 
    
    //add the layer now
    VImap.addLayer(VILayer);
    
    //*******************************
    //Northeast States
    var NELayer = new esri.layers.ArcGISDynamicMapServiceLayer("//" + serverName + "/ArcGIS/rest/services/" + fishMSFolder + "/" + advWhereULiveMSName + "/MapServer");    
    
    //Setup popup for ST abbreviation as user moves mouse
    var NEInfoWindow = new myModules.InfoWindow({ 
      domNode: dojo.create("infoBorderDiv", null, dojo.byId("NEmap")) 
    });
    
    NEmap = new esri.Map("NEmap",{extent:NEastExtent, infoWindow:NEInfoWindow, logo:false});    
    NELayer.setVisibleLayers([7]);
    
    //Setup popup for ST abbreviation as user moves mouse
    //Listen for infoWindow onHide event
    dojo.connect(NEmap.infoWindow, "onHide", function() {NEmap.graphics.clear();});
    
    
    //turn off all zooms/pans - this has to happen in the onLoad function of the map
    dojo.connect(NEmap, "onLoad", function() { NEmap.disableMapNavigation(); NEmap.hideZoomSlider(); });    
    
    //When the user clicks a state we want to open the app and let them choose a waterbody.
    dojo.connect(NEmap, "onClick", function(evt){ initFishMap(evt,"US");  }); 
    
    //add the layer now
    NEmap.addLayer(NELayer);   
       
    //resize the map when the browser resizes - view the 'Resizing and repositioning the map' section in 
    //the following help topic for more details http://help.esri.com/EN/webapi/javascript/arcgis/help/jshelp_start.htm#jshelp/inside_guidelines.htm
    var resizeTimer;
    dojo.connect(clickMap, 'onLoad', function(theMap) {
      dojo.connect(dijit.byId('clickMap'), 'resize', function() {  //resize the map if the div is resized
        clearTimeout(resizeTimer);
        resizeTimer = setTimeout( function() {
          clickMap.resize();
          clickMap.reposition();
        }, 500);
      });
    });
}

function addBaseLayers()
{
    //Add the street and imagery layers to the map
    
    //enable following line for the ESRI street map
    streetLayer = new esri.layers.ArcGISTiledMapServiceLayer(streetLayerURL);
    
    //enable following lines for Bing street map
//    streetLayer = new esri.virtualearth.VETiledLayer(
//    {
//        bingMapsKey: esriBingMapsKey,
//        mapStyle: esri.virtualearth.VETiledLayer.MAP_STYLE_ROAD
//    });

    //enable following line for the ESRI imagery map
    imageryLayer = new esri.layers.ArcGISTiledMapServiceLayer(imageryLayerURL);

    //enable following lines for Bing imagery map
    //imageryLayer = new esri.virtualearth.VETiledLayer(
    //{
    //    bingMapsKey: esriBingMapsKey,
    //    mapStyle: esri.virtualearth.VETiledLayer.MAP_STYLE_AERIAL
    //});
    
    map.addLayer(streetLayer);
    map.addLayer(imageryLayer);
    
    //hide imagery layer
    imageryLayer.hide();
    
    //show imagery button
    btnImageryMap.SetVisible(true);
    
    //hide street button
    btnStreetMap.SetVisible(false);
    
    //send base layers to back of map
    map.reorderLayer(streetLayer, 1);
    map.reorderLayer(imageryLayer, 0);   
}

function toggleBaseMap()
{
    //toggle the base map layer - default is street map
    //in addition, show/hide button for switching to the other basemap - imagery button is shown by default
    if (streetLayer.visible)
    {
        streetLayer.hide();
        imageryLayer.show();
        map.reorderLayer(imageryLayer, 0);
        btnImageryMap.SetVisible(false);
        btnStreetMap.SetVisible(true);
    }
    else
    {
        imageryLayer.hide();
        streetLayer.show();
        map.reorderLayer(streetLayer, 0);
        btnStreetMap.SetVisible(false);
        btnImageryMap.SetVisible(true);
    }
}

function toggleCloseButton(active)
{
    if (active)
    {
        $("#wbClose").css("background-image", "url(images/close-active.png)");
    }
    else
    {
        $("#wbClose").css("background-image", "url(images/close-default.png)");
    }
}

function addCollapsibleSearch(searchDivName)
{
    //create buttons to show/hide intro text when clicked
    $("#btnShowSearch").attr("title", showSearchText);
    //$("#btnShowSearch").attr("value", showSearchText);
    $("#btnShowSearch").button(
    {
        icons: { primary: "ui-icon-circle-plus" }
    })
    .click(function()
    {
        $("#" + searchDivName).show("slide");
        $("#btnHideSearch").show();
        $("#btnShowSearch").hide();
        return false;
    });
        $("#btnHideSearch").attr("title", hideSearchText);
        //$("#btnHideSearch").attr("value", hideSearchText);
        $("#btnHideSearch").button(
    {
        icons: { primary: "ui-icon-circle-minus" }
    })
    .click(function()
    {
        $("#" + searchDivName).hide("slide");
        $("#btnShowSearch").show();
        $("#btnHideSearch").hide();
        return false;
    });
    $("#btnShowSearch").hide();
}

function arcgisErrorHandler(error){
    if (error.message.indexOf("timeout") > -1){
        //error was a timeout
        alert("A timeout error occurred during the mapping process.  The server may be busy or your query request may have been too large.  Please try again in a few minutes or try to refine your query.");
    }else{
        alert("An unexpected error occurred during the mapping process.  Error details: " + error.message);
    }
    esri.hide(dojo.byId("mapStatus"));

}

function hideWaterbodyPopUp(){

    esri.hide(dojo.byId('waterbodyPopUpDiv'));
    map.graphics.clear(); 
    numIdentifyPopUpCounter=0;
    textShow=""; 
    boolFedText=false;       
    if (dojo.byId(strAdvNumHiddenVarName)) { 
        dojo.byId(strAdvNumHiddenVarName).value="";
    }
}
