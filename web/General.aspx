<%@ page title="<%$ Resources:GlobalResources, GeneralPageTitle %>" language="VB" masterpagefile="~/Site.master" autoeventwireup="false" inherits="NLFA.General, App_Web_general.aspx.cdcab7d2" enableEventValidation="false" viewStateEncryptionMode="Never" %>

<%@ Register Assembly="DevExpress.Web.v10.1, Version=10.1.9.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web.ASPxRoundPanel" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.v10.1, Version=10.1.9.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web.ASPxPanel" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.ASPxEditors.v10.1, Version=10.1.9.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web.ASPxEditors" TagPrefix="dx" %>

<asp:Content ID="cStyles" ContentPlaceHolderID="cpStyles" Runat="Server">
    <link rel="stylesheet" type="text/css" href="//serverapi.arcgisonline.com/jsapi/arcgis/2.2/js/dojo/dijit/themes/tundra/tundra.css" />
    <link rel="stylesheet" type="text/css" href="//serverapi.arcgisonline.com/jsapi/arcgis/2.2/js/esri/dijit/css/popup.css" />
    <link rel="stylesheet" type="text/css" href="jquery/css/black-tie/jquery-ui-1.8.16.custom.css" />
    <link rel="stylesheet" type="text/css" href="css/layout.css" />
    <link rel="stylesheet" type="text/css" href="myModules/infowindow.css" />
</asp:Content>
<asp:Content ID="cScripts" ContentPlaceHolderID="cpScripts" Runat="Server">
    <script type="text/javascript" src="jquery/js/jquery-3.6.3.min.js"></script>
    <script type="text/javascript" src="jquery/js/PatchJQuery.js"></script>
    <script type="text/javascript" src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js" integrity="sha256-lSjKY0/srUM9BE3dPm+c4fBo1dky2v27Gdjm2uoZaL0=" crossorigin="anonymous"></script>
    <script type="text/javascript" src="javascript/json2.js"></script>
    <script type="text/javascript">
        var djConfig =
        {
            parseOnLoad: true,
            baseUrl: "./",
            modulePaths:
            {
                "myModules": "./myModules"
            }
        };                  
    </script>
    <script type="text/javascript" src="//serverapi.arcgisonline.com/jsapi/arcgis/?v=2.2"></script>
    <script type="text/javascript" src="javascript/globalParams.js"></script>
    <script type="text/javascript" src="javascript/layout.js"></script>  
    <script type="text/javascript" src="javascript/zoomTools.js"></script> 
    <script type="text/javascript" src="javascript/identify_query.js"></script>
    <script type="text/javascript" src="javascript/identify_geom.js"></script>
    <script type="text/javascript">
        var webmap, title, subtitle, owner, bingMapsKey;
        var boolClickableMap=false;   
        var txtMapTooMuchData="<%= MapTooMuchData%>";
        var txtDefinitionsURL="<%= GeneralDefinitionsURL %>";
        //run the init function on page load
        dojo.addOnLoad(init);
        function init()
        {
            try
            {
                //resize the map content based on window height
                ResizeMapContent();
                $(window).resize(function()
                {
                    ResizeMapContent();
                });                
                //check if map already loaded
                var mapLoaded = dojo.byId("ctl00_cpContent_pnlMap_hfMapLoaded").value;
                if (mapLoaded == "0")
                {

                    //Adjust the height and width of the inset windows based on the size
                    //of the main map.  The inset windows are always square and the max
                    //width is 100px
                    var insetWidth=80;
                    var bottomValUpper=120;
                    var bottomValLower=10; 
                    var horizPaddingVal=25;                   
                    
                    $("#insetWinAK").css("width", insetWidth);
                    $("#insetWinAK").css("height", insetWidth);
                    $("#insetWinAK").css("bottom", bottomValUpper);
                    $("#insetWinHI").css("width", insetWidth);
                    $("#insetWinHI").css("height", insetWidth);
                    $("#insetWinHI").css("bottom", bottomValLower);
                    $("#insetWinVI").css("width", insetWidth);
                    $("#insetWinVI").css("height", insetWidth); 
                    $("#insetWinVI").css("bottom", bottomValLower);                   
                    $("#insetWinPR").css("width", insetWidth);
                    $("#insetWinPR").css("height", insetWidth);
                    $("#insetWinPR").css("bottom", bottomValLower);
                    $("#insetWinNE").css("width", insetWidth);
                    $("#insetWinNE").css("height", insetWidth);
                    $("#insetWinNE").css("bottom", bottomValUpper);                    
                    $("#insetWinGuam").css("width", insetWidth);
                    $("#insetWinGuam").css("height", insetWidth);
                    $("#insetWinGuam").css("bottom", bottomValLower);
                    $("#insetWinAS").css("width", insetWidth);
                    $("#insetWinAS").css("height", insetWidth);
                    $("#insetWinAS").css("bottom", bottomValLower);
                    
                    //Adjust the inset windows that are on the right of map so sit where they should
//                    $("#insetWinVI").css("left", minMapWidth-insetWidth-insetWidth-80);
//                    $("#insetWinNE").css("left", minMapWidth - insetWidth - 50);
//                    $("#insetWinPR").css("left", minMapWidth - insetWidth - 50);
//                    $("#insetWinVI").css("right", insetWidth+horizPaddingVal);
//                    $("#insetWinNE").css("right", bottomValLower);
//                    $("#insetWinPR").css("right", bottomValLower);
                    
                    adjustMapWin();
                    
                    //disable the search button when the page is first loaded
                    btnMap.SetEnabled(false);

                    //set value to indicate first map is loaded
                    dojo.byId("ctl00_cpContent_pnlMap_hfMapLoaded").value = "1";

                    //load the first map

                    //ID for map from ArcGIS.com
                    webmap = "dbd1c6d52f4e447f8c01d14a691a70fe";
                    //initialize map
                    initAdvisoriesWhereYouLive();
                }
                else if (mapLoaded == "1")
                {
                    adjustMapWin();
//                    $("#mapContent").css("width", "100%");
//                    $("#mapContent").css("height", "100%");                                        
//                    $("#clickMap").css("width", "100%");
//                    $("#clickMap").css("height", "100%");
                    
                    //set value to indicate second map is loaded
                    dojo.byId("ctl00_cpContent_pnlMap_hfMapLoaded").value = "2";

                    //load the second map
                    initFishMap(null, null);
                }
                else if (mapLoaded == "2")
                {
                    adjustMapWin();
                    
                    var st = dojo.byId("ctl00_cpContent_pnlMap_StateSelected").value;
                    getStateExtent(st,true,false);
                }
            }
            catch (ex)
            {
                var errMsg = "An unexpected error occurred.\n\n";
                errMsg = errMsg + "Error description: " + ex.description + "\n\n";
                errMsg = errMsg + "Click OK to continue.\n\n";
                alert(errMsg);
            }
        }
        
        function adjustMapWin(){
            boolClickableMap=false;                        
            $("#mapContent").css("width", "100%");
            $("#mapContent").css("height", "100%");                                        
            $("#clickMap").css("width", "100%");
            $("#clickMap").css("height", "100%");
            ResizeMapContent();
            
        }

        function ddlState_SelectedIndexChanged()
        {
            try
            {
                resetMapItems();
                if (ddlState.GetValue() != null)
                {
                    var stateName = ddlState.GetText();
                    var stateInfo = ddlState.GetValue().split("~");
                    var stateId = stateInfo[0];
                    var stateUrl = stateInfo[1];
                    dojo.byId("ctl00_cpContent_pnlMap_StateSelected").value = stateId;
                    lblMapCaption.SetText(stateName);
                    var waterbodyMsg = "<%= WaterbodyMsg %>";
                    var website = "<%= Website %>";
                    if (stateUrl == "")
                    {
                        waterbodyMsg = waterbodyMsg.replace("{0}", "<b><a href='NoStateSite.aspx?st=" + stateName + "' target='_blank'>" + stateName + " " + website + "</a></b>")
                    }
                    else
                    {
                        waterbodyMsg = waterbodyMsg.replace("{0}", "<b><a href='" + stateUrl + "' target='_blank' title='" + stateUrl + "'>" + stateName + " " + website + "</a></b>")
                    }
                    dojo.byId("ctl00_cpContent_pnlQuery_lblWaterbodyMsg").innerHTML = waterbodyMsg;
                }
                else
                {
                    dojo.byId("ctl00_cpContent_pnlMap_StateSelected").value = "";
                    btnMap.SetEnabled(false);
                    lblMapCaption.SetText("");
                    dojo.byId("ctl00_cpContent_pnlQuery_lblWaterbodyMsg").value = "";
                }
                ddlWaterbody.PerformCallback(dojo.byId("ctl00_cpContent_pnlMap_StateSelected").value);
                resetWaterbodyControls();
            }
            catch (ex)
            {
                var errMsg = "An unexpected error occurred.\n\n";
                errMsg = errMsg + "Error description: " + ex.description + "\n\n";
                errMsg = errMsg + "Click OK to continue.\n\n";
                alert(errMsg);
            }
        }

        function ddlWaterbody_SelectedIndexChanged()
        {
            try
            {
                if (ddlWaterbody.GetValue() != null)
                {
                    btnMap.SetEnabled(true);
                    dojo.byId("ctl00_cpContent_pnlMap_WaterbodySelected").value = ddlWaterbody.GetValue();
                    $.ajax(
                    {
                        type: "POST",
                        url: window.location.href + "/GetWaterbodyMbr",
                        data: '{"state":"' + dojo.byId("ctl00_cpContent_pnlMap_StateSelected").value + '","waterbody":"' + dojo.byId("ctl00_cpContent_pnlMap_WaterbodySelected").value + '"}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function(data, status)
                        {
                            if (data != null)
                            {
                                var result = jQuery.parseJSON(data.d);
                                dojo.byId("ctl00_cpContent_pnlMap_WaterbodyMinX").value = result.MinX;
                                dojo.byId("ctl00_cpContent_pnlMap_WaterbodyMinY").value = result.MinY;
                                dojo.byId("ctl00_cpContent_pnlMap_WaterbodyMaxX").value = result.MaxX;
                                dojo.byId("ctl00_cpContent_pnlMap_WaterbodyMaxY").value = result.MaxY;
                            }
                        },
                        error: function(data, status, errormsg)
                        {
                            var errorDetails = data.responseText;
                            alert("An error occurred:  " + errorDetails.Message);
                        }
                    });
                }
                else
                {
                    btnMap.SetEnabled(false);
                    resetWaterbodyControls();
                }
            }
            catch (ex)
            {
                var errMsg = "An unexpected error occurred.\n\n";
                errMsg = errMsg + "Error description: " + ex.description + "\n\n";
                errMsg = errMsg + "Click OK to continue.\n\n";
                alert(errMsg);
            }
        }

        function ddlWaterbody_EndCallback()
        {
            //disable the search button if no waterbodies were returned when a state was selected
            if (ddlWaterbody.GetItemCount() == 0)
            {
                btnMap.SetEnabled(false);
            }
        }

        function resetWaterbodyControls()
        {
            dojo.byId("ctl00_cpContent_pnlMap_WaterbodySelected").value = "";
            dojo.byId("ctl00_cpContent_pnlMap_WaterbodyMinX").value = "";
            dojo.byId("ctl00_cpContent_pnlMap_WaterbodyMinY").value = "";
            dojo.byId("ctl00_cpContent_pnlMap_WaterbodyMaxX").value = "";
            dojo.byId("ctl00_cpContent_pnlMap_WaterbodyMaxY").value = "";
        }

        function ResizeMapContent()
        {
//            if (boolClickableMap === false) //don't resize map height for clickable map
//            {
                var areaAboveMap = 255; //height of area above map
                var areaLeftOfMap = 425; //width of area to left of map
                //determine window height and width
                var windowHeight = $(window).height();
                var windowWidth = $(window).width();
                //determine map height and width
                //height = window height - area above map
                //width = window width - area to left of map
                var mapHeight = windowHeight - areaAboveMap;
                var mapWidth = windowWidth - areaLeftOfMap;
                //if calculated map height is less than global minimum height, set map height to global minimum
                if (mapHeight < minMapHeight) 
                {
                    mapHeight = minMapHeight;
                }
                //if calculated map width is less than global minimum width, set map width to global minimum
                if (mapWidth < minMapWidth)
                {
                    mapWidth = minMapWidth;
                }
                //add calculated height and width to map div
                $("#mapContent").css("height", mapHeight);
                $("#mapContent").css("width", mapWidth);
//            }                                    
        }

    </script>
</asp:Content>
<asp:Content ID="cPageTitleBreadcrumb" ContentPlaceHolderID="cpPageTitleBreadcrumb" Runat="Server">
    <asp:Label ID="lblPageTitleBreadcrumb" runat="server" Text="<%$ Resources:GlobalResources, GeneralTitle %>"></asp:Label>
</asp:Content>
<asp:Content ID="cPageTitle" ContentPlaceHolderID="cpPageTitle" Runat="Server">
    <asp:Label ID="lblPageTitle" runat="server" Text="<%$ Resources:GlobalResources, GeneralTitle %>"></asp:Label>
</asp:Content>
<asp:Content ID="cContent" ContentPlaceHolderID="cpContent" Runat="Server">
    
    <%--<div id="description" class="ui-corner-all">
        <p>
            <asp:Label ID="lblGeneralDescription1" runat="server" Text="<%$ Resources:GlobalResources, GeneralDescription1 %>"></asp:Label>
        </p>
        <p>
            <asp:Label ID="lblGeneralDescription2" runat="server" Text="<%$ Resources:GlobalResources, GeneralDescription2 %>"></asp:Label>&nbsp;<asp:HyperLink ID="lnkTechnicalAdvisories" runat="server" Text="<%$ Resources:GlobalResources, TechnicalAdvisoriesURLText %>" ToolTip="<%$ Resources:GlobalResources, TechnicalAdvisoriesURLText %>" Target="_self" NavigateUrl="<%$ Resources:GlobalResources, TechnicalAdvisoriesURL %>"></asp:HyperLink>.&nbsp;<asp:Label ID="lblGeneralDescription3" runat="server" Text="<%$ Resources:GlobalResources, GeneralDescription3 %>"></asp:Label>&nbsp;<asp:HyperLink ID="lnkGeneralUserGuide" runat="server" Text="<%$ Resources:GlobalResources, GeneralUserGuideURLText %>" ToolTip="<%$ Resources:GlobalResources, GeneralUserGuideURLText %>" Target="_self" NavigateUrl="<%$ Resources:GlobalResources, GeneralUserGuideURL %>"></asp:HyperLink>.
        </p>
    </div>--%>
    
    <asp:ScriptManager ID="smContent" runat="server" />
   
    <table id="contentTable">
        <tr>
            <td class="content-left">
                                   
	<p style="color:#0071bc;">This database contains historical information on fish advisories. For current advisories click on the <a href="Contacts.aspx">State, Territory and Tribe Fish Advisory Contacts</a>.</p>

                <dx:ASPxRoundPanel ID="pnlQuery" runat="server"  ForeColor="#000" HeaderText="<%$ Resources:GlobalResources, GeneralOptionsHeader %>" Font-Names="Lucida Sans" CssFilePath="~/App_Themes/Silver/{0}/styles.css" CssPostfix="Silver" ImageFolder="~/App_Themes/Silver/{0}/" ShowDefaultImages="False" ShowHeader="True" Width="100%" Height="100%">              
                    <BottomRightCorner Height="10px" Url="~/App_Themes/Silver/Web/rpBottomRightCorner.gif" Width="6px">
                    </BottomRightCorner>
                    <Border BorderColor="#D7D7D7" BorderStyle="Solid" BorderWidth="1px" />
                    <BottomEdge>
                        <BackgroundImage ImageUrl="~/App_Themes/Silver/Web/rpBottomBack.gif" Repeat="RepeatX" />
                    </BottomEdge>
                    <TopRightCorner Height="6px" Url="~/App_Themes/Silver/Web/rpTopRightCorner.gif" Width="6px">
                    </TopRightCorner>
                    <BorderBottom BorderWidth="0px" />
                    
                    <PanelCollection>
                        <dx:PanelContent ID="pcQuery" runat="server">
                        
                            <div id="queryBodyGeneral">
                                <table id="queryTable">
                                    <tr>
                                        <td class="heading-left">
                                            <dx:ASPxLabel runat="server" Text="<%$ Resources:GlobalResources, State %>" AssociatedControlID="ddlState" Font-Names="Lucida Sans" ID="lblState" ForeColor="Black">
                                            </dx:ASPxLabel>
                                        </td>
                                        <td>
                                            <dx:ASPxComboBox runat="server" ID="ddlState" ClientInstanceName="ddlState" IncrementalFilteringMode="StartsWith" CallbackPageSize="1000" DataSourceID="odsState" TextField="NAME" ValueField="STATE" AutoPostBack="False" EnableSynchronization="False" Font-Names="Lucida Sans" CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass" LoadingPanelImagePosition="Top" ShowShadow="False" SpriteCssFilePath="~/App_Themes/BlackGlass/{0}/sprite.css" Width="240px" ToolTip="<%$ Resources:GlobalResources, StateToolTip %>">
                                                <LoadingPanelImage Url="~/App_Themes/BlackGlass/Editors/Loading.gif">
                                                </LoadingPanelImage>
                                                <DropDownButton>
                                                    <Image>
                                                        <SpriteProperties HottrackedCssClass="dxEditors_edtDropDownHover_BlackGlass" PressedCssClass="dxEditors_edtDropDownPressed_BlackGlass" />
                                                    </Image>
                                                </DropDownButton>
                                                <ValidationSettings>
                                                    <ErrorFrameStyle ImageSpacing="4px">
                                                        <ErrorTextPaddings PaddingLeft="4px" />
                                                    </ErrorFrameStyle>
                                                </ValidationSettings>
                                                <ClientSideEvents SelectedIndexChanged="function(s, e) { ddlState_SelectedIndexChanged(); init(); }" />
                                            </dx:ASPxComboBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="heading-left">
                                            <dx:ASPxLabel runat="server" ID="lblWaterbody" Text="<%$ Resources:GlobalResources, Waterbody %>" AssociatedControlID="ddlWaterbody" Font-Names="Lucida Sans" ForeColor="Black" Wrap="True">
                                            </dx:ASPxLabel>
                                        </td>
                                        <td>
                                            <dx:ASPxComboBox runat="server" ID="ddlWaterbody" ClientInstanceName="ddlWaterbody" EnableCallbackMode="True" CallbackPageSize="1000" IncrementalFilteringMode="Contains" DataSourceID="odsWaterbody" TextField="WATERBODY" ValueField="WATERBODY" AutoPostBack="False" EnableSynchronization="False" Font-Names="Lucida Sans" CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass" LoadingPanelImagePosition="Top" ShowShadow="False" SpriteCssFilePath="~/App_Themes/BlackGlass/{0}/sprite.css" Width="240px" ToolTip="<%$ Resources:GlobalResources, WaterbodyToolTip %>">
                                                <LoadingPanelImage Url="~/App_Themes/BlackGlass/Editors/Loading.gif">
                                                </LoadingPanelImage>
                                                <DropDownButton>
                                                    <Image>
                                                        <SpriteProperties HottrackedCssClass="dxEditors_edtDropDownHover_BlackGlass" PressedCssClass="dxEditors_edtDropDownPressed_BlackGlass" />
                                                    </Image>
                                                </DropDownButton>
                                                <ValidationSettings>
                                                    <ErrorFrameStyle ImageSpacing="4px">
                                                        <ErrorTextPaddings PaddingLeft="4px" />
                                                    </ErrorFrameStyle>
                                                </ValidationSettings>
                                                <ClientSideEvents SelectedIndexChanged="function(s, e) { ddlWaterbody_SelectedIndexChanged(); }" EndCallback="function(s, e) { ddlWaterbody_EndCallback(); }" />
                                            </dx:ASPxComboBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <table>
                                                <tr>
                                                    <td class="button">
                                                        <dx:ASPxButton runat="server" Text="<%$ Resources:GlobalResources, Search %>" Font-Bold="True" Font-Names="Lucida Sans" ToolTip="<%$ Resources:GlobalResources, SearchMapToolTip %>" ID="btnMap" ClientInstanceName="btnMap" CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass" SpriteCssFilePath="~/App_Themes/BlackGlass/{0}/sprite.css" AutoPostBack="false">
                                                            <ClientSideEvents Click="function(s, e){ resetMapItems(); selectWaterbody();  }" />
                                                        </dx:ASPxButton>
                                                    </td>
                                                    <td class="button">
                                                        <dx:ASPxButton runat="server" Text="<%$ Resources:GlobalResources, Reset %>" Font-Bold="True" Font-Names="Lucida Sans" ToolTip="<%$ Resources:GlobalResources, ResetToolTip %>" ID="btnReset" CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass" SpriteCssFilePath="~/App_Themes/BlackGlass/{0}/sprite.css">
                                                        </dx:ASPxButton>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" class="heading-general">
                                            <asp:Label ID="lblWaterbodyMsg" runat="server" ClientInstanceName="lblWaterbodyMsg" Font-Names="Lucida Sans" ForeColor="#356697" Width="280px" Wrap="True">
                                            </asp:Label>
                                            <hr class="divider" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" class="heading-general">
                                            <asp:Label ID="lblHelpTitle" runat="server" Text="<%$ Resources:GlobalResources, HelpTitle %>" Font-Bold="true"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <ul>
                                                <li>
                                                    <asp:HyperLink ID="lnkAdvisoryWaterbodyHelp" runat="server" Font-Names="Lucida Sans" ForeColor="#356697" Width="280px" Text="<%$ Resources:GlobalResources, AdvisoryWaterbodyHelp %>" ToolTip="<%$ Resources:GlobalResources, AdvisoryWaterbodyHelp %>" NavigateUrl="<%$ Resources:GlobalResources, AdvisoryWaterbodyHelpURL %>" Target="_blank"></asp:HyperLink>                              
                                                </li>
                                                <li>
                                                    <asp:HyperLink ID="lnkAdvisoryDetailsHelp" runat="server" Font-Names="Lucida Sans" ForeColor="#356697" Width="280px" Text="<%$ Resources:GlobalResources, AdvisoryDetailsHelp %>" ToolTip="<%$ Resources:GlobalResources, AdvisoryDetailsHelp %>" NavigateUrl="<%$ Resources:GlobalResources, AdvisoryDetailsHelpURL %>" Target="_blank"></asp:HyperLink>                            
                                                </li>
                                                <li>
                                                    <asp:HyperLink ID="lnkAdvisoriesHelp" runat="server" Font-Names="Lucida Sans" ForeColor="#356697" Width="280px" Text="<%$ Resources:GlobalResources, AdvisoriesDefinitions %>" ToolTip="<%$ Resources:GlobalResources, AdvisoriesDefinitionsToolTip %>" NavigateUrl="<%$ Resources:GlobalResources, AdvisoriesDefinitionsURL %>" Target="_blank"></asp:HyperLink>
                                                </li>
                                                <li>
                                                    <asp:HyperLink ID="lnkUserGuide" runat="server" Font-Names="Lucida Sans" ForeColor="#356697" Text="<%$ Resources:GlobalResources, GeneralUserGuideURLText %>" ToolTip="<%$ Resources:GlobalResources, GeneralUserGuideURLText %>" NavigateUrl="<%$ Resources:GlobalResources, GeneralUserGuideURL %>" Target="_blank"></asp:HyperLink>
                                                </li>
                                            </ul>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <asp:HyperLink ID="lnkContacts" runat="server" Font-Names="Lucida Sans" Font-Bold="true" Text="<%$ Resources:GlobalResources, ContactsLink %>" ToolTip="<%$ Resources:GlobalResources, ContactsLinkToolTip %>" NavigateUrl="<%$ Resources:GlobalResources, ContactsLinkURL %>" Target="_blank"></asp:HyperLink>
                                        </td>
                                    </tr>
                                    <tr>                                
                                        <td colspan="2" class="legend-container">
                                            <div id="LayerVisibleDiv" class="legend ui-corner-all"> 
                                                <div class="legendTitle"><asp:Label ID="lblOptionsHeader" runat="server" Text="<%$ Resources:GlobalResources, MapOptionsHeader %>"></asp:Label></div>
                                                <br />
                                                <div id="SelectedLegendDiv">
                                                    <asp:Label ID="lblResultsTitle" runat="server" Text="<%$ Resources:GlobalResources, MapResultsTitle %>"></asp:Label>
                                                    <br /><br />
				                                    <div id="SelectedDetailsTitle" class="legendIndent1"></div>                                                                      <br />
				                                </div>
                                                <div id="IdentifyLegendDiv">
                                                    <asp:Label ID="lblIdentifyHelp" runat="server" Text="<%$ Resources:GlobalResources, IdentifyHelp %>"></asp:Label>
                                                    <br /><br />
				                                    <div id="IdentifyDetailsTitle" class="legendIndent2"></div>
				                                    <hr class="divider" />
                                                </div>
                                                <asp:Label ID="lblOptionsTitle" runat="server" Text="<%$ Resources:GlobalResources, MapOptionsTitle %>"></asp:Label>
                                                <br />   
                                                <div id="FishPopDiv">
                                                    <div id="FishPopDetailsTitle" class="legendIndent1"></div>
                                                    <div id="FishPopDetailsDiv" class="legendIndent2"></div>
                                                    <br />
                                                </div>  
                                                <div id="RegionalDiv">
                                                    <div id="RegionalDetailsTitle" class="legendIndent1"></div>
                                                    <div id="RegionalDetailsDiv" class="legendIndent2"></div>
                                                    <br />
                                                </div> 
                                                <div id="StatewideDiv">
                                                    <div id="StatewideDetailsTitle" class="legendIndent1"></div>
                                                    <div id="StatewideDetailsDiv" class="legendIndent2"></div>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            
                                <asp:ObjectDataSource ID="odsState" runat="server" SelectMethod="AllStates" TypeName="NLFA.OracleDataProvider" EnableCaching="True" CacheDuration="600" CacheExpirationPolicy="Sliding"></asp:ObjectDataSource>
                                <asp:ObjectDataSource ID="odsWaterbody" runat="server" SelectMethod="GeneralWaterbodyList" TypeName="NLFA.OracleDataProvider" EnableCaching="True" CacheDuration="600" CacheExpirationPolicy="Sliding">
                                    <SelectParameters>
                                        <asp:ControlParameter ControlID="pnlMap$StateSelected" Name="state" />
                                    </SelectParameters>
                                </asp:ObjectDataSource>
                            </div>
                            
                        </dx:PanelContent>
                    </PanelCollection>
                    
                    <TopLeftCorner Height="6px" Url="~/App_Themes/Silver/Web/rpTopLeftCorner.gif" Width="6px">
                    </TopLeftCorner>
                    <BackgroundImage ImageUrl="~/App_Themes/Silver/Web/rpContentBack.gif" Repeat="RepeatX" />
                    <BottomLeftCorner Height="10px" Url="~/App_Themes/Silver/Web/rpBottomLeftCorner.gif" Width="6px">
                    </BottomLeftCorner>
                    
                </dx:ASPxRoundPanel>
            </td>
            <td class="content-right">
            
                <span id="mapStatus" class="ui-widget-content ui-corner-all ui-state-highlight">
                    <asp:Label ID="lblLoading" runat="server" Text="<%$ Resources:GlobalResources, Loading %>"></asp:Label>
                    &nbsp;
                    <asp:Image ID="imgLoading" runat="server" ImageUrl="images/trout.gif" ImageAlign="Middle" ToolTip="<%$ Resources:GlobalResources, Loading %>" />
                </span>
            
                <dx:ASPxRoundPanel ID="pnlMap" runat="server" Font-Names="Lucida Sans" 
                    CssFilePath="~/App_Themes/Silver/{0}/styles.css" CssPostfix="Silver" 
                    Width="100%" Height="100%" ForeColor="#356697"
                    ShowHeader="False" ImageFolder="~/App_Themes/Silver/{0}/" 
                    ShowDefaultImages="False">              
                    <BottomRightCorner Height="10px" 
                        Url="~/App_Themes/Silver/Web/rpBottomRightCorner.gif" Width="6px">
                    </BottomRightCorner>
                    <Border BorderColor="#D7D7D7" BorderStyle="Solid" BorderWidth="1px" />
                    <BottomEdge>
                        <BackgroundImage ImageUrl="~/App_Themes/Silver/Web/rpBottomBack.gif" 
                            Repeat="RepeatX" />
                    </BottomEdge>
                    <TopRightCorner Height="6px" Url="~/App_Themes/Silver/Web/rpTopRightCorner.gif" 
                        Width="6px">
                    </TopRightCorner>
                    <BorderBottom BorderWidth="0px" />
                    
                    <PanelCollection>
                        <dx:PanelContent ID="pcMap" runat="server">
                        
                            <asp:HiddenField runat="server" id="hfMapLoaded" />
                            <asp:HiddenField runat="server" id="StateSelected" />
                            <asp:HiddenField runat="server" id="WaterbodySelected" />
                            <asp:HiddenField runat="server" id="WaterbodyMinX" />
                            <asp:HiddenField runat="server" id="WaterbodyMinY" />
                            <asp:HiddenField runat="server" id="WaterbodyMaxX" />
                            <asp:HiddenField runat="server" id="WaterbodyMaxY" />
                            <asp:HiddenField runat="server" id="AdvisoryNumber" />
                            
                            <div id="mapContent">
                                <div id="mapCaption">
                                    <dx:ASPxLabel runat="server" Font-Names="Lucida Sans" ID="lblMapCaption" ClientInstanceName="lblMapCaption" Text="<%$ Resources:GlobalResources, GeneralMapCaption %>" Height="10px" style="float:left"></dx:ASPxLabel>
                                    <dx:ASPxButton runat="server" ID="btnStreetMap" ClientInstanceName="btnStreetMap" Text="<%$ Resources:GlobalResources, StreetMap %>" ToolTip="<%$ Resources:GlobalResources, StreetMapToolTip %>"  AutoPostBack="false" UseSubmitBehavior="false" CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass" SpriteCssFilePath="~/App_Themes/BlackGlass/{0}/sprite.css" Font-Names="Lucida Sans" Font-Size="0.9em" Height="10px" Width="120px" style="float:right">
                                        <ClientSideEvents Click="function(s, e){ toggleBaseMap(); }" />
                                    </dx:ASPxButton>
                                    <dx:ASPxButton runat="server" ID="btnImageryMap" ClientInstanceName="btnImageryMap" Text="<%$ Resources:GlobalResources, ImageryMap %>" ToolTip="<%$ Resources:GlobalResources, ImageryMapToolTip %>" AutoPostBack="false" UseSubmitBehavior="false" CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass" SpriteCssFilePath="~/App_Themes/BlackGlass/{0}/sprite.css" Font-Names="Lucida Sans" Font-Size="0.9em" Height="10px" Width="120px" style="float:right">
                                        <ClientSideEvents Click="function(s, e){ toggleBaseMap(); }" />
                                    </dx:ASPxButton>
                                </div>
                                
                                <div id="mapBodyGeneral" class="tundra">
                                         
                                    <div id="mainWindowGeneral" dojotype="dijit.layout.BorderContainer" design="headline">
                                    
                                        <!-- Map Section -->
                                        <div id="map" dojotype="dijit.layout.ContentPane" region="center">
                                            <div id="clickMap" dojotype="dijit.layout.ContentPane" region="center" style="width:100%; height:100%; ">
                                                <div id="insetWinAK" class="shadow" style="position:absolute; left:15px; bottom:165px; z-Index:998; width:100px;height:100px;">
                                                     <div id="AKmap" dojotype="dijit.layout.ContentPane" style="width:100%;height:100%;">
                                                    <span id="AKLabel" style="position:absolute;z-index:100;right:45px;top:5px;padding:5px;">
                                                    AK</span>
                                                    </div>
                                                </div>
                                                <div id="insetWinHI" class="shadow" style="position:absolute; left:15px; bottom:35px; z-Index:998; width:100px;height:100px; ">
                                                     <div id="HImap" dojotype="dijit.layout.ContentPane" style="width:100%;height:100%;">
                                                    <span id="HILabel" style="position:absolute;z-index:100;right:45px;top:5px;padding:5px;">
                                                     HI</span>
                                                     </div>
                                                </div>
                                                <div id="insetWinNE" class="shadow" style="position:absolute; right:15px; bottom:165px; z-Index:998; width:100px;height:100px; ">
                                                     <div id="NEmap" dojotype="dijit.layout.ContentPane" style="width:100%;height:100%;">
                                                     <span id="NELabel" style="position:absolute;z-index:100;right:30px;top:0px;padding:2px;">
                                                     Northeast</span>
                                                     </div>
                                                </div>
                                                <div id="insetWinVI" class="shadow" style="position:absolute; right:140px; bottom:35px; z-Index:998; width:100px;height:100px; ">
                                                     <div id="VImap" dojotype="dijit.layout.ContentPane" style="width:100%;height:100%;">
                                                     <span id="VILabel" style="position:absolute;z-index:100;right:45px;top:5px;padding:5px;">
                                                     VI</span>
                                                     </div>
                                                </div>
                                                <div id="insetWinPR" class="shadow" style="position:absolute; right:15px; bottom:35px; z-Index:998; width:100px;height:100px; ">
                                                     <div id="PRmap" dojotype="dijit.layout.ContentPane" style="width:100%;height:100%;">
                                                     <span id="PRLabel" style="position:absolute;z-index:100;right:45px;top:5px;padding:5px;">
                                                     PR</span>
                                                     </div>
                                                </div>
                                                <div id="insetWinAS" class="shadow" style="position:absolute; left:140px; bottom:35px; z-Index:998; width:100px;height:100px; ">
                                                     <div id="ASmap" dojotype="dijit.layout.ContentPane" style="width:100%;height:100%;">
                                                     <span id="ASLabel" style="position:absolute;z-index:100;right:45px;top:5px;padding:5px;">
                                                     AS</span>
                                                     </div>
                                                </div>
                                                <div id="insetWinGuam" class="shadow" style="position:absolute; left:270px; bottom:35px; z-Index:998; width:100px;height:100px; ">
                                                     <div id="Guammap" dojotype="dijit.layout.ContentPane" style="width:100%;height:100%;">
                                                     <span id="GuamLabel" style="position:absolute;z-index:100;right:37px;top:5px;padding:5px;">
                                                     Guam</span>
                                                     </div>
                                                </div>
                                            </div>                                    
                                        </div>
                                        
                                        <!-- Identify info window  -->
                                        <div id="idResultsBorder" dojotype="dijit.layout.BorderContainer">
                                            <div id="idResults" dojotype="dijit.layout.ContentPane"></div>
                                        </div>
                                        
                                        <!-- Popup info window for clickable map  -->
                                        <div id="infoBorderDiv" dojotype="dijit.layout.BorderContainer"> 
                                            <div id="info" dojotype="dijit.layout.ContentPane"></div>           
                                        </div>
                                        
                                        <!-- Popup info window for general site's waterbody query  -->
                                        <div id="waterbodyPopUpDiv" dojotype="dijit.layout.BorderContainer">
                                            <div id="wbTitle" dojotype="dijit.layout.ContentPane" class="title"></div>    
                                            <div id="wbClose" onclick="hideWaterbodyPopUp();numWbPopUpCounter=0;" onmouseover="toggleCloseButton(true);" onmouseout="toggleCloseButton(false);" onmousedown="toggleCloseButton(true);" onmouseup="toggleCloseButton(false);" class="close close-default"></div>
                                            <div id="wbContent" dojotype="dijit.layout.ContentPane" class="content"></div>
                                        </div>
                                        
                                    </div>
                                    
                                </div>
                            </div>
                            
                        </dx:PanelContent>
                    </PanelCollection>
                    
                    <TopLeftCorner Height="6px" Url="~/App_Themes/Silver/Web/rpTopLeftCorner.gif" 
                        Width="6px">
                    </TopLeftCorner>
                    <BackgroundImage ImageUrl="~/App_Themes/Silver/Web/rpContentBack.gif" 
                        Repeat="RepeatX" />
                    <BottomLeftCorner Height="10px" 
                        Url="~/App_Themes/Silver/Web/rpBottomLeftCorner.gif" Width="6px">
                    </BottomLeftCorner>
                    
                </dx:ASPxRoundPanel>   
                         
            </td>
        </tr>
    </table>
</asp:Content>

