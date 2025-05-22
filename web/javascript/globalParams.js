//Name of map server

//production
var serverName="map24.epa.gov"; 

//development
//var serverName = "rabbit";


//Name of arcgis manager folder where NLFA Map Services are located
var fishMSFolder="NLFA";

//Name of FISH_GEN Map Service - general site's map service
var fishGenMSName="FISH_GEN"; //FISH_GEN

//Name of FISH_TECH Map Service - technical site map service
var fishTechMSName="FISH_TECH"; //FISH_TECH

//Name of Advisories Where you live map service (clickable states to start app)
var advWhereULiveMSName="Clickable_Map";

//Name of FISH_TISSUE Map Service - Fish tissue map service
var fishTissueMSName = "FISH_TISSUE_SUMMARY";

//Name of Statewide/Regional Advisory Map Service used for general site (active advisories only)
var stateRegionalActiveMSName="Statewide_General_ACTIVE";

//Name of Statewide/Regional Advisory Map Service used for technical site (active and rescinded advisories)
var stateRegionalTechMSName="Statewide_Technical_Active_Rescinded";

//Name of URL Location of streets basemap layer
var streetLayerURL="//server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer";

//Name of URL Location of imagery basemap layer
var imageryLayerURL = "//server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer";

//Key for Bing maps
var esriBingMapsKey = "Ai6vOzMmk6A5FZlsslke-nterE5MgHBlUQNP4kb0rjE2kqbt8lrcaPt7HSNc1L-3";

//Number of Layer WEB_SESSION_RESULTS in the FISH_TECH map service (from NLFA db)
var numTechWebSessionResultLayer=11;

//Number of Layer WEB_SESSION_RESULTS in the FISH_TISSUE_SUMMARY map service (from NLFA db)
var numTissueWebSessionResultLayer=12;

//Number of Layer WATERBODY_ADVISORIES table in the FISH_GEN map service (from NLFA db)
//This is used for the General site
var numWaterbodiesLayer=12;

//Number of layer ADVISORY_INFO View in FISH_GEN map service (from NLFA Attribute database)
var advisoryInfoViewGenLayerNum=11; 

//Number of layer ADVISORY_INFO View in FISH_TECH map service (from NLFA Attribute database)
var advisoryInfoViewTechLayerNum=12;

//Number of layer ALL_TISSUE_STATIONS View in FISH_TISSUE_SUMMARY map service (from NLFA Attribute database)
//This is used for the Tissue site
var tissueViewLayerNum = 11; 

//url for Advisory Details report
var advisoryDetailsURL = "AdvisoryDetails.aspx?ADVNUM=";

//url for Fish Tissue Details report
var fishTissueDetailsURL = "FishTissueDetails.aspx?STATION_ID=";

//show search text
var showSearchText = "Click to expand search";

//hide search text
var hideSearchText = "Click to collapse search";

//name of dblink
//var strDBLink="epad6.nlfwa";

//name of state field to query on for general site (only show state user selected)
var stFieldName = "ST";

//URL for proxy server
var proxyURL = "proxy.ashx";

//minimum pixel width of map
var minMapWidth=745;

//minimum pixel height of map
var minMapHeight=550;