<%@ page language="VB" masterpagefile="~/Site.master" autoeventwireup="false" inherits="NLFA.Advisories, App_Web_advisories.aspx.cdcab7d2" title="<%$ Resources:GlobalResources, TechnicalAdvisoriesPageTitle %>" enableEventValidation="false" viewStateEncryptionMode="Never" %>

<%@ Register Assembly="DevExpress.Web.ASPxGridView.v10.1.Export, Version=10.1.9.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"Namespace="DevExpress.Web.ASPxGridView.Export" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v10.1, Version=10.1.9.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web.ASPxRoundPanel" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v10.1, Version=10.1.9.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web.ASPxPanel" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v10.1, Version=10.1.9.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxTabControl" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v10.1, Version=10.1.9.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxClasses" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.ASPxEditors.v10.1, Version=10.1.9.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web.ASPxEditors" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.ASPxGridView.v10.1, Version=10.1.9.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web.ASPxGridView" TagPrefix="dx" %>

<asp:Content ID="cStyles" ContentPlaceHolderID="cpStyles" Runat="Server">
    <link rel="stylesheet" type="text/css" href="//serverapi.arcgisonline.com/jsapi/arcgis/2.2/js/dojo/dijit/themes/tundra/tundra.css" />
    <link rel="stylesheet" type="text/css" href="//serverapi.arcgisonline.com/jsapi/arcgis/2.2/js/esri/dijit/css/Popup.css" />
    <link rel="stylesheet" type="text/css" href="jquery/css/black-tie/jquery-ui-1.8.16.custom.css" />
    <link rel="stylesheet" type="text/css" href="css/layout.css" />
</asp:Content>
<asp:Content ID="cScripts" ContentPlaceHolderID="cpScripts" Runat="Server">

    <script type="text/javascript" src="jquery/js/jquery-3.6.3.min.js"></script>
    <script type="text/javascript" src="jquery/js/PatchJQuery.js"></script>
    <script type="text/javascript" src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js" integrity="sha256-lSjKY0/srUM9BE3dPm+c4fBo1dky2v27Gdjm2uoZaL0=" crossorigin="anonymous"></script>
    <script type="text/javascript">
        var djConfig = { parseOnLoad: true, baseUrl: "./", modulePaths: { "myModules": "./myModules"}}; 
    </script>
    <script type="text/javascript" src="//serverapi.arcgisonline.com/jsapi/arcgis/?v=2.2"></script>
    <script type="text/javascript" src="javascript/globalParams.js"></script>
    <script type="text/javascript" src="javascript/layout.js"></script>
    <script type="text/javascript" src="javascript/zoomTools.js"></script>
    <script type="text/javascript" src="javascript/TechQueryMap.js"></script>
    <script type="text/javascript" src="javascript/identify_query.js"></script>
    <script type="text/javascript" src="javascript/identify_geom.js"></script>
    <script type="text/javascript">
    var txtMapTooMuchData="<%= MapTooMuchData%>";
    var txtDefinitionsURL="<%= TechnicalDefinitionsURL %>";
    function bindEvents()
    {
        //add collapsible search box
        addCollapsibleSearch("queryBodyAdvisory");
        //update the map
        dojo.addOnLoad(UpdateMap);
    }
    function UpdateMap()
    {
        try
        {
            //hide the query loading status
            HideLoading("queryStatus");
            //resize the map content based on window height
            ResizeMapContent();
            $(window).resize(function()
            {
                ResizeMapContent();
            });
            //check if map tab is active
            if (pcResults.GetActiveTabIndex() == 0)
            {
                //update the map caption
                lblMapCaption.SetText(dojo.byId("ctl00_cpContent_pnlQuery_hfMapCaption").value);
                //check if map already loaded
                var mapLoaded = dojo.byId("ctl00_cpContent_pcResults_hfMapLoaded").value;
                if (mapLoaded == "0")
                {
                    //check if a value exists in the Advisory Number hidden field
                    //(this means the user has clicked on a link in the report and we need to zoom to an item)
                    var advisoryNumber = null;
                    if (dojo.byId(strAdvNumHiddenVarName).value != "")
                    {
                        //if so, store the number then reset the hidden field
                        advisoryNumber = dojo.byId(strAdvNumHiddenVarName).value;
                        dojo.byId(strAdvNumHiddenVarName).value = "";
                    }                    
                    //map not loaded, so load it
                    init(fishTechMSName, advisoryNumber);
                    //set flag to indicate map was loaded
                    dojo.byId("ctl00_cpContent_pcResults_hfMapLoaded").value = "1";
                }
                else
                {
                    //map already loaded so update map with new results only                   
                    doTechnicalQuery();
                }
            }
            else
            {
                //hide the map loading status
                HideLoading("mapStatus");
            }
        }
        catch (ex)
        {
            HideLoading("mapStatus");
            var errMsg = "An unexpected error occurred.\n\n";
            errMsg = errMsg + "Error description: " + ex.description + "\n\n";
            errMsg = errMsg + "Click OK to continue.\n\n";
            alert(errMsg);
        }
    }
    function PreventQuery()
    {
        dojo.byId("ctl00_cpContent_pnlQuery_hfDoMapQuery").value = "0";
        dojo.byId("ctl00_cpContent_pnlQuery_hfDoReportQuery").value = "0";
    }
    function ShowLoading(divName)
    {
        $("body").css("cursor", "wait");
        esri.show(dojo.byId(divName));
    }
    function HideLoading(divName)
    {
        esri.hide(dojo.byId(divName));
        $("body").css("cursor", "");
    }
    function CheckSelections()
    {
        //if user queries map without refining query below region level, display a message       
        if ((ddlState.GetText() == "<%= All %>") && (ddlWaterbody.GetText() == "<%= All %>") && (ddlAdvisoryType.GetText() == "<%= All %>") && (ddlFishSpecies.GetText() == "<%= All %>") && (ddlPollutant.GetText() == "<%= All %>") && (ddlPopulation.GetText() == "<%= All %>"))
        {
            return false;
        }
        else
        {
            return true;
        }
    }
    function ShowSearchError()
    {
        alert("<%= SearchError %>");
    }
    function ResizeMapContent()
    {
        var areaAboveMap = 275; //height of area above map
        var areaLeftOfMap = 360; //width of area to left of map
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
    }
    </script>
    
</asp:Content>
<asp:Content ID="cPageTitleBreadcrumb" ContentPlaceHolderID="cpPageTitleBreadcrumb" Runat="Server">
    <asp:Label ID="lblPageTitleBreadcrumb" runat="server" Text="<%$ Resources:GlobalResources, TechnicalAdvisoriesTitle %>"></asp:Label>
</asp:Content>
<asp:Content ID="cPageTitle" ContentPlaceHolderID="cpPageTitle" Runat="Server">
    <asp:Label ID="lblPageTitle" runat="server" Text="<%$ Resources:GlobalResources, TechnicalAdvisoriesTitle %>"></asp:Label>
</asp:Content>

<asp:Content ID="cContent" ContentPlaceHolderID="cpContent" Runat="Server">

    <div id="helpLinks">
        <table>
            <tr>
                <td>
                    <asp:HyperLink ID="lnkContacts" runat="server" Font-Names="Lucida Sans" Font-Bold="true" Text="<%$ Resources:GlobalResources, ContactsLink %>" ToolTip="<%$ Resources:GlobalResources, ContactsLinkToolTip %>" NavigateUrl="<%$ Resources:GlobalResources, ContactsLinkURL %>" Target="_blank"></asp:HyperLink>
                </td>
                <td>
                    <asp:HyperLink ID="lnkAdvisoriesHelp" runat="server" Font-Names="Lucida Sans" ImageUrl="~/images/help.gif" ToolTip="<%$ Resources:GlobalResources, TechAdvisoriesHelpURLText %>" NavigateUrl="<%$ Resources:GlobalResources, TechAdvisoriesHelpURL %>" Target="_blank"></asp:HyperLink>
                </td>
            </tr>
        </table>
    </div>
	
    <asp:ScriptManager ID="smContent" runat="server" />   

    <table id="contentTable">
        <tr>
            <td class="content-left">
                <span id="queryStatus" class="ui-widget-content ui-corner-all ui-state-highlight">
                    <asp:Label ID="lblReportLoading" runat="server" Text="<%$ Resources:GlobalResources, Loading %>"></asp:Label>
                    &nbsp;
                    <asp:Image ID="imgReportLoading" runat="server" ImageUrl="images/trout.gif" ImageAlign="Middle" ToolTip="<%$ Resources:GlobalResources, Loading %>" />
                </span>
                
	<p style="color:#0071bc;">This database contains historical information on fish advisories from 1974 to 2011. For current advisories click on the <a href="Contacts.aspx">State, Territory and Tribe Fish Advisory Contacts</a>.</p>

                <dx:ASPxRoundPanel ID="pnlQuery" runat="server" HeaderText="<%$ Resources:GlobalResources, SearchOptionsHeader %>" Font-Names="Lucida Sans" ForeColor="Black" CssFilePath="~/App_Themes/Silver/{0}/styles.css" HorizontalAlign="Left" CssPostfix="Silver" ImageFolder="~/App_Themes/Silver/{0}/" ShowDefaultImages="False" ShowHeader="True" Width="100%">              
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
                        
                             <asp:UpdatePanel ID="upContent" runat="server">
                                 <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="btnMap" EventName="Click" />
                                    <asp:PostBackTrigger ControlID="btnReport" />
                                    <asp:PostBackTrigger ControlID="btnReset" />
                                 </Triggers>
                                 <ContentTemplate>
                                        
                                    <script type="text/javascript">
                                    Sys.Application.add_load(bindEvents);
                                    </script>
                                    
                                    <div id="toggleSearch">
                                        <button id="btnShowSearch">&nbsp;</button>
                                        <button id="btnHideSearch">&nbsp;</button>
                                    </div>
                                    <div id="toggleSearchSpacer">&nbsp;</div>
                                    
                                    <div id="queryBodyAdvisory">
                                    
                                        <table id="queryTable">
                                            <tr>
                                                <td class="heading">
                                                    <dx:ASPxLabel runat="server" Text="<%$ Resources:GlobalResources, Region %>" AssociatedControlID="ddlEpaRegion" Font-Names="Lucida Sans" ID="lblEpaRegion"></dx:ASPxLabel>
                                                </td>
                                                <td>
                                                    <dx:ASPxComboBox runat="server" EnableCallbackMode="True" IncrementalFilteringMode="Contains" CallbackPageSize="200000" ValueType="System.String" DataSourceID="odsEpaRegions" TextField="REGION" ValueField="REGION" AutoPostBack="True" Font-Names="Lucida Sans" ID="ddlEpaRegion" OnDataBound="ddlQueryList_DataBound" OnSelectedIndexChanged="ddlQueryList_SelectedIndexChanged" CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass" LoadingPanelImagePosition="Top" ShowShadow="False" SpriteCssFilePath="~/App_Themes/BlackGlass/{0}/sprite.css" ClientInstanceName="ddlEpaRegion" EnableViewState="false">
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
                                                        <ClientSideEvents SelectedIndexChanged="function(s, e){ ShowLoading('queryStatus'); PreventQuery(); }" EndCallback="function(s, e){ HideLoading('queryStatus'); }" />
                                                    </dx:ASPxComboBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="heading">
                                                    <dx:ASPxLabel runat="server" Text="<%$ Resources:GlobalResources, State %>" AssociatedControlID="ddlState" Font-Names="Lucida Sans" ID="lblState"></dx:ASPxLabel>
                                                </td>
                                                <td>
                                                    <dx:ASPxComboBox runat="server" EnableCallbackMode="True" IncrementalFilteringMode="StartsWith" CallbackPageSize="200000" ValueType="System.String" DataSourceID="odsState" TextField="NAME" ValueField="STATE" AutoPostBack="True" Font-Names="Lucida Sans" ID="ddlState" OnDataBound="ddlQueryList_DataBound" OnSelectedIndexChanged="ddlQueryList_SelectedIndexChanged" CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass" LoadingPanelImagePosition="Top" ShowShadow="False" SpriteCssFilePath="~/App_Themes/BlackGlass/{0}/sprite.css" ClientInstanceName="ddlState" EnableViewState="false">         
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
                                                        <ClientSideEvents SelectedIndexChanged="function(s, e){ ShowLoading('queryStatus'); PreventQuery(); }" EndCallback="function(s, e){ HideLoading('queryStatus'); }" />
                                                    </dx:ASPxComboBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="heading">
                                                    <dx:ASPxLabel runat="server" Text="<%$ Resources:GlobalResources, Waterbody %>" AssociatedControlID="ddlWaterbody" Font-Names="Lucida Sans" ID="lblWaterbody"></dx:ASPxLabel>
                                                </td>
                                                <td>
                                                    <dx:ASPxComboBox runat="server" EnableCallbackMode="True" IncrementalFilteringMode="Contains" CallbackPageSize="200000" ValueType="System.String" DataSourceID="odsWaterbody" TextField="ADVISORY" ValueField="ADVISORY" AutoPostBack="True" Font-Names="Lucida Sans" ID="ddlWaterbody" OnDataBound="ddlQueryList_DataBound" OnSelectedIndexChanged="ddlQueryList_SelectedIndexChanged" CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass" LoadingPanelImagePosition="Top" ShowShadow="False" SpriteCssFilePath="~/App_Themes/BlackGlass/{0}/sprite.css" ClientInstanceName="ddlWaterbody" EnableViewState="false">
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
                                                        <ClientSideEvents SelectedIndexChanged="function(s, e){ ShowLoading('queryStatus'); PreventQuery(); }" EndCallback="function(s, e){ HideLoading('queryStatus'); }" />
                                                    </dx:ASPxComboBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="heading">
                                                    <dx:ASPxLabel runat="server" Text="<%$ Resources:GlobalResources, Type %>" AssociatedControlID="ddlAdvisoryType" Font-Names="Lucida Sans" ID="lblAdvisoryType"></dx:ASPxLabel>
                                                </td>
                                                <td>
                                                    <dx:ASPxComboBox runat="server" EnableCallbackMode="True" IncrementalFilteringMode="Contains" CallbackPageSize="200000" ValueType="System.Int32" DataSourceID="odsAdvisoryType" TextField="ADV_TYPE" ValueField="ADVISORY_TYPE_ID" AutoPostBack="True" Font-Names="Lucida Sans" ID="ddlAdvisoryType" OnDataBound="ddlQueryList_DataBound" OnSelectedIndexChanged="ddlQueryList_SelectedIndexChanged" CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass" LoadingPanelImagePosition="Top" ShowShadow="False" SpriteCssFilePath="~/App_Themes/BlackGlass/{0}/sprite.css" ClientInstanceName="ddlAdvisoryType" EnableViewState="false">
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
                                                        <ClientSideEvents SelectedIndexChanged="function(s, e){ ShowLoading('queryStatus'); PreventQuery(); }" EndCallback="function(s, e){ HideLoading('queryStatus'); }" />
                                                    </dx:ASPxComboBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="heading">
                                                    <dx:ASPxLabel runat="server" Text="<%$ Resources:GlobalResources, Species %>" AssociatedControlID="ddlFishSpecies" Font-Names="Lucida Sans" ID="lblFishSpecies"></dx:ASPxLabel>
                                                </td>
                                                <td>
                                                    <dx:ASPxComboBox runat="server" EnableCallbackMode="True" IncrementalFilteringMode="Contains" CallbackPageSize="200000" ValueType="System.Int32" DataSourceID="odsFishSpecies" TextField="SPECIES" ValueField="SPECIES_ID" AutoPostBack="True" Font-Names="Lucida Sans" ID="ddlFishSpecies" OnDataBound="ddlQueryList_DataBound" OnSelectedIndexChanged="ddlQueryList_SelectedIndexChanged" CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass" LoadingPanelImagePosition="Top" ShowShadow="False" SpriteCssFilePath="~/App_Themes/BlackGlass/{0}/sprite.css" ClientInstanceName="ddlFishSpecies" EnableViewState="false">
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
                                                        <ClientSideEvents SelectedIndexChanged="function(s, e){ ShowLoading('queryStatus'); PreventQuery(); }" EndCallback="function(s, e){ HideLoading('queryStatus'); }" />
                                                    </dx:ASPxComboBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="heading">
                                                    <dx:ASPxLabel runat="server" Text="<%$ Resources:GlobalResources, Pollutant %>" AssociatedControlID="ddlPollutant" Font-Names="Lucida Sans" ID="lblPollutant"></dx:ASPxLabel>
                                                </td>
                                                <td>
                                                    <dx:ASPxComboBox runat="server" EnableCallbackMode="True" IncrementalFilteringMode="Contains" CallbackPageSize="200000" ValueType="System.Int32" DataSourceID="odsPollutant" TextField="POLLUTANT" ValueField="POLLUTANT_ID" AutoPostBack="True" Font-Names="Lucida Sans" ID="ddlPollutant" OnDataBound="ddlQueryList_DataBound" OnSelectedIndexChanged="ddlQueryList_SelectedIndexChanged" CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass" LoadingPanelImagePosition="Top" ShowShadow="False" SpriteCssFilePath="~/App_Themes/BlackGlass/{0}/sprite.css" ClientInstanceName="ddlPollutant" EnableViewState="false">
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
                                                        <ClientSideEvents SelectedIndexChanged="function(s, e){ ShowLoading('queryStatus'); PreventQuery(); }" EndCallback="function(s, e){ HideLoading('queryStatus'); }" />
                                                    </dx:ASPxComboBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="heading">
                                                    <dx:ASPxLabel runat="server" Text="<%$ Resources:GlobalResources, Population %>" AssociatedControlID="ddlPopulation" Font-Names="Lucida Sans" ID="lblPopulation"></dx:ASPxLabel>
                                                </td>
                                                <td>
                                                    <dx:ASPxComboBox runat="server" EnableCallbackMode="True" IncrementalFilteringMode="Contains" CallbackPageSize="200000" ValueType="System.Int32" DataSourceID="odsPopulation" TextField="POPTEXT" ValueField="POPULATION_ID" AutoPostBack="True" Font-Names="Lucida Sans" ID="ddlPopulation" OnDataBound="ddlQueryList_DataBound" OnSelectedIndexChanged="ddlQueryList_SelectedIndexChanged" CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass" LoadingPanelImagePosition="Top" ShowShadow="False" SpriteCssFilePath="~/App_Themes/BlackGlass/{0}/sprite.css" ClientInstanceName="ddlPopulation" EnableViewState="false">
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
                                                        <ClientSideEvents SelectedIndexChanged="function(s, e){ ShowLoading('queryStatus'); PreventQuery(); }" EndCallback="function(s, e){ HideLoading('queryStatus'); }" />
                                                    </dx:ASPxComboBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="heading">
                                                    <dx:ASPxLabel runat="server" Text="<%$ Resources:GlobalResources, Status %>" AssociatedControlID="ddlStatus" Font-Names="Lucida Sans" ID="lblStatus"></dx:ASPxLabel>
                                                </td>
                                                <td>
                                                    <dx:ASPxComboBox runat="server" EnableCallbackMode="True" IncrementalFilteringMode="Contains" CallbackPageSize="200000" ValueType="System.String" DataSourceID="odsStatus" TextField="ADVISORY_STATUS" ValueField="ADVISORY_STATUS" AutoPostBack="True" Font-Names="Lucida Sans" ID="ddlStatus" OnDataBound="ddlQueryList_DataBound" OnSelectedIndexChanged="ddlQueryList_SelectedIndexChanged" CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass" LoadingPanelImagePosition="Top" ShowShadow="False" SpriteCssFilePath="~/App_Themes/BlackGlass/{0}/sprite.css" ClientInstanceName="ddlStatus" EnableViewState="false">
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
                                                        <ClientSideEvents SelectedIndexChanged="function(s, e){ ShowLoading('queryStatus'); PreventQuery(); }" EndCallback="function(s, e){ HideLoading('queryStatus'); }" />
                                                    </dx:ASPxComboBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="heading" colspan="2">
                                                    <dx:ASPxLabel runat="server" Text="<%$ Resources:GlobalResources, Year %>" Font-Names="Lucida Sans" ID="lblYear"></dx:ASPxLabel>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="heading">
                                                    <dx:ASPxLabel runat="server" Text="<%$ Resources:GlobalResources, From %>" AssociatedControlID="ddlStartYear" Font-Names="Lucida Sans" ID="lblStartYear"></dx:ASPxLabel>
                                                </td>
                                                <td>
                                                    <dx:ASPxComboBox runat="server" EnableCallbackMode="True" IncrementalFilteringMode="Contains" CallbackPageSize="200000" ValueType="System.String" DataSourceID="odsYear" TextField="YEAR_ISSUED" ValueField="YEAR_ISSUED" AutoPostBack="True" Font-Names="Lucida Sans" ID="ddlStartYear" OnDataBound="ddlQueryList_DataBound" OnSelectedIndexChanged="ddlStartYear_SelectedIndexChanged" CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass" LoadingPanelImagePosition="Top" ShowShadow="False" SpriteCssFilePath="~/App_Themes/BlackGlass/{0}/sprite.css" ClientInstanceName="ddlStartYear" EnableViewState="false">
                                                        <ButtonStyle Width="11px">
                                                        </ButtonStyle>
                                                        <LoadingPanelImage Url="~/App_Themes/BlackGlass/Editors/Loading.gif">
                                                        </LoadingPanelImage>
                                                        <ValidationSettings ErrorText="Error has occurred">
                                                            <ErrorFrameStyle ImageSpacing="4px">
                                                                <ErrorTextPaddings PaddingLeft="4px" />
                                                            </ErrorFrameStyle>
                                                        </ValidationSettings>
                                                        <ClientSideEvents SelectedIndexChanged="function(s, e){ ShowLoading('queryStatus'); PreventQuery(); }" EndCallback="function(s, e){ HideLoading('queryStatus'); }" />
                                                    </dx:ASPxComboBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="heading">
                                                    <dx:ASPxLabel runat="server" Text="<%$ Resources:GlobalResources, To %>" AssociatedControlID="ddlEndYear" Font-Names="Lucida Sans" ID="lblEndYear"></dx:ASPxLabel>
                                                </td>
                                                <td>
                                                    <dx:ASPxComboBox runat="server" EnableCallbackMode="True" IncrementalFilteringMode="Contains" CallbackPageSize="200000" ValueType="System.String" DataSourceID="odsYear" TextField="YEAR_ISSUED" ValueField="YEAR_ISSUED" AutoPostBack="True" Font-Names="Lucida Sans" ID="ddlEndYear" OnDataBound="ddlQueryList_DataBound" OnSelectedIndexChanged="ddlEndYear_SelectedIndexChanged" CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass" LoadingPanelImagePosition="Top" ShowShadow="False" SpriteCssFilePath="~/App_Themes/BlackGlass/{0}/sprite.css" ClientInstanceName="ddlEndYear" EnableViewState="false">
                                                        <ButtonStyle Width="11px">
                                                        </ButtonStyle>
                                                        <LoadingPanelImage Url="~/App_Themes/BlackGlass/Editors/Loading.gif">
                                                        </LoadingPanelImage>
                                                        <ValidationSettings ErrorText="Error has occurred">
                                                            <ErrorFrameStyle ImageSpacing="4px">
                                                                <ErrorTextPaddings PaddingLeft="4px" />
                                                            </ErrorFrameStyle>
                                                        </ValidationSettings>
                                                        <ClientSideEvents SelectedIndexChanged="function(s, e){ ShowLoading('queryStatus'); PreventQuery(); }" EndCallback="function(s, e){ HideLoading('queryStatus'); }" />
                                                    </dx:ASPxComboBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2" valign="bottom">
                                                    <table>
                                                        <tr>
                                                            <td class="button">
                                                                <dx:ASPxButton runat="server" Text="<%$ Resources:GlobalResources, Search %>" Font-Bold="True" Font-Names="Lucida Sans" ToolTip="<%$ Resources:GlobalResources, SearchMapToolTip %>" ID="btnMap" CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass" SpriteCssFilePath="~/App_Themes/BlackGlass/{0}/sprite.css">
                                                                    <ClientSideEvents Click="function(s, e){ resetMapItems(); ShowLoading('mapStatus'); if (!CheckSelections()) { e.processOnServer = false; ShowSearchError(); HideLoading('mapStatus'); } else {  } }" Init="function(s, e){ HideLoading('mapStatus'); }" />
                                                                </dx:ASPxButton>
                                                                <dx:ASPxButton runat="server" Text="<%$ Resources:GlobalResources, Search %>" Font-Bold="True" Font-Names="Lucida Sans" ToolTip="<%$ Resources:GlobalResources, SearchReportToolTip %>" ID="btnReport" CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass" SpriteCssFilePath="~/App_Themes/BlackGlass/{0}/sprite.css"></dx:ASPxButton>
                                                            </td>
                                                            <td class="button">
                                                                <dx:ASPxButton runat="server" Text="<%$ Resources:GlobalResources, Reset %>" Font-Bold="True" Font-Names="Lucida Sans" ToolTip="<%$ Resources:GlobalResources, ResetToolTip %>" ID="btnReset" CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass" SpriteCssFilePath="~/App_Themes/BlackGlass/{0}/sprite.css">
                                                                </dx:ASPxButton>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                            
                                        </table>
                                        
                                    </div>
                                        
                                    <asp:ObjectDataSource ID="odsEpaRegions" runat="server" SelectMethod="EpaRegionList" TypeName="NLFA.OracleDataProvider" EnableCaching="True" CacheDuration="600" CacheExpirationPolicy="Sliding">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="ddlState" Name="state" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlWaterbody" Name="waterbody" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlAdvisoryType" Name="advisoryType" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlFishSpecies" Name="species" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlPollutant" Name="pollutant" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlPopulation" Name="population" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlStatus" Name="status" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlStartYear" Name="startYear" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlEndYear" Name="endYear" PropertyName="SelectedItem.Value" Type="String" />
                                        </SelectParameters>
                                    </asp:ObjectDataSource>
                                    
                                    <asp:ObjectDataSource ID="odsState" runat="server" SelectMethod="StateList" TypeName="NLFA.OracleDataProvider" EnableCaching="True" CacheDuration="600" CacheExpirationPolicy="Sliding">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="ddlEpaRegion" Name="region" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlWaterbody" Name="waterbody" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlAdvisoryType" Name="advisoryType" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlFishSpecies" Name="species" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlPollutant" Name="pollutant" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlPopulation" Name="population" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlStatus" Name="status" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlStartYear" Name="startYear" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlEndYear" Name="endYear" PropertyName="SelectedItem.Value" Type="String" />
                                        </SelectParameters>
                                    </asp:ObjectDataSource>
                                    
                                    <asp:ObjectDataSource ID="odsWaterbody" runat="server" SelectMethod="WaterbodyList" TypeName="NLFA.OracleDataProvider" EnableCaching="True" CacheDuration="600" CacheExpirationPolicy="Sliding">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="ddlEpaRegion" Name="region" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlState" Name="state" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlAdvisoryType" Name="advisoryType" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlFishSpecies" Name="species" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlPollutant" Name="pollutant" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlPopulation" Name="population" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlStatus" Name="status" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlStartYear" Name="startYear" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlEndYear" Name="endYear" PropertyName="SelectedItem.Value" Type="String" />
                                        </SelectParameters>
                                    </asp:ObjectDataSource>
                                    
                                    <asp:ObjectDataSource ID="odsAdvisoryType" runat="server" SelectMethod="AdvisoryTypeList" TypeName="NLFA.OracleDataProvider" EnableCaching="True" CacheDuration="600" CacheExpirationPolicy="Sliding">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="ddlEpaRegion" Name="region" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlState" Name="state" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlWaterbody" Name="waterbody" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlFishSpecies" Name="species" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlPollutant" Name="pollutant" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlPopulation" Name="population" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlStatus" Name="status" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlStartYear" Name="startYear" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlEndYear" Name="endYear" PropertyName="SelectedItem.Value" Type="String" />
                                        </SelectParameters>
                                    </asp:ObjectDataSource>
                                        
                                    <asp:ObjectDataSource ID="odsFishSpecies" runat="server" SelectMethod="FishSpeciesList" TypeName="NLFA.OracleDataProvider" EnableCaching="True" CacheDuration="600" CacheExpirationPolicy="Sliding">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="ddlEpaRegion" Name="region" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlState" Name="state" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlWaterbody" Name="waterbody" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlAdvisoryType" Name="advisoryType" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlPollutant" Name="pollutant" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlPopulation" Name="population" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlStatus" Name="status" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlStartYear" Name="startYear" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlEndYear" Name="endYear" PropertyName="SelectedItem.Value" Type="String" />
                                        </SelectParameters>
                                    </asp:ObjectDataSource>
                                    
                                    <asp:ObjectDataSource runat="server" ID="odsPollutant" SelectMethod="PollutantList" TypeName="NLFA.OracleDataProvider" EnableCaching="True" CacheDuration="600" CacheExpirationPolicy="Sliding">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="ddlEpaRegion" Name="region" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlState" Name="state" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlWaterbody" Name="waterbody" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlAdvisoryType" Name="advisoryType" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlFishSpecies" Name="species" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlPopulation" Name="population" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlStatus" Name="status" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlStartYear" Name="startYear" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlEndYear" Name="endYear" PropertyName="SelectedItem.Value" Type="String" />
                                        </SelectParameters>
                                    </asp:ObjectDataSource>
                                    
                                    <asp:ObjectDataSource ID="odsPopulation" runat="server" SelectMethod="PopulationList" TypeName="NLFA.OracleDataProvider" EnableCaching="True" CacheDuration="600" CacheExpirationPolicy="Sliding">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="ddlEpaRegion" Name="region" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlState" Name="state" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlWaterbody" Name="waterbody" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlAdvisoryType" Name="advisoryType" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlFishSpecies" Name="species" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlPollutant" Name="pollutant" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlStatus" Name="status" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlStartYear" Name="startYear" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlEndYear" Name="endYear" PropertyName="SelectedItem.Value" Type="String" />
                                        </SelectParameters>
                                    </asp:ObjectDataSource>
                                    
                                    <asp:ObjectDataSource ID="odsStatus" runat="server" SelectMethod="StatusList" TypeName="NLFA.OracleDataProvider" EnableCaching="True" CacheDuration="600" CacheExpirationPolicy="Sliding">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="ddlEpaRegion" Name="region" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlState" Name="state" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlWaterbody" Name="waterbody" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlAdvisoryType" Name="advisoryType" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlFishSpecies" Name="species" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlPollutant" Name="pollutant" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlPopulation" Name="population" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlStartYear" Name="startYear" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlEndYear" Name="endYear" PropertyName="SelectedItem.Value" Type="String" />
                                        </SelectParameters>
                                    </asp:ObjectDataSource>
                                    
                                    <asp:ObjectDataSource runat="server" SelectMethod="YearList" TypeName="NLFA.OracleDataProvider" ID="odsYear" EnableCaching="True" CacheDuration="600" CacheExpirationPolicy="Sliding">
                                        <SelectParameters>
                                             <asp:ControlParameter ControlID="ddlEpaRegion" Name="region" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlState" Name="state" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlWaterbody" Name="waterbody" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="ddlAdvisoryType" Name="advisoryType" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlFishSpecies" Name="species" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlPollutant" Name="pollutant" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlPopulation" Name="population" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="ddlStatus" Name="status" PropertyName="SelectedItem.Value" Type="String" />
                                        </SelectParameters>
                                    </asp:ObjectDataSource>
                                    
                                    <asp:HiddenField ID="hfMapCaption" runat="server" />
                                    <asp:HiddenField ID="hfDoMapQuery" runat="server" />
                                    <asp:HiddenField ID="hfDoReportQuery" runat="server" />
                                 </ContentTemplate>
                            </asp:UpdatePanel>
                            
                        </dx:PanelContent>
                    </PanelCollection>
                                    
                    <TopLeftCorner Height="6px" Url="~/App_Themes/Silver/Web/rpTopLeftCorner.gif" Width="6px">
                    </TopLeftCorner>
                    <BackgroundImage ImageUrl="~/App_Themes/Silver/Web/rpContentBack.gif" Repeat="RepeatX" />
                    <BottomLeftCorner Height="10px" Url="~/App_Themes/Silver/Web/rpBottomLeftCorner.gif" Width="6px">
                    </BottomLeftCorner>
                    
                </dx:ASPxRoundPanel>

                <dx:ASPxRoundPanel ID="pnlOptions" runat="server"
                    HeaderText="<%$ Resources:GlobalResources, MapOptionsHeader %>" Font-Names="Lucida Sans" ForeColor="Black"
                    CssFilePath="~/App_Themes/Silver/{0}/styles.css" 
                    CssPostfix="Silver" ImageFolder="~/App_Themes/Silver/{0}/" 
                    ShowDefaultImages="False" ShowHeader="True" Width="100%">              
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
                        <dx:PanelContent ID="pcOptions" runat="server">
                            
                            <div id="legendBody">
                                    
                                <div id="LayerVisibleDiv">
                                    <asp:Label ID="lblResultsTitle" runat="server" Text="<%$ Resources:GlobalResources, MapResultsTitle %>"></asp:Label>
                                    <br /><br />
                                    <div id="SelectedLegendDiv">
                                        <div id="SelectedDetailsTitle" class="legendIndent1"></div>
                                    </div>
                                    <br />
                                    <asp:Label ID="lblIdentifyHelp" runat="server" Text="<%$ Resources:GlobalResources, IdentifyHelp %>"></asp:Label>
                                    <br /><br />
                                    <div id="IdentifyLegendDiv">
                                        <div id="IdentifyDetailsTitle" class="legendIndent2"></div>
                                    </div>
                                    
                                    <hr class="divider" />
                                    
                                    <asp:Label ID="lblOptionsTitle" runat="server" Text="<%$ Resources:GlobalResources, MapOptionsTitle %>"></asp:Label>
                                    <br /><br />
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
                <dx:ASPxPageControl ID="pcResults" runat="server" ClientInstanceName="pcResults" CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass" Width="100%" Height="100%" ActiveTabIndex="0" AutoPostBack="true" EnableCallBacks="true">
                    <LoadingPanelImage Url="~/App_Themes/BlackGlass/Web/Loading.gif">
                    </LoadingPanelImage>
                    <ContentStyle>
                        <Border BorderWidth="1px" BorderColor="#4E4F51" BorderStyle="Solid" />
                    </ContentStyle>
                    <ClientSideEvents TabClick="function(s, e){ if (s.GetActiveTabIndex() == 1)
                    { if (!CheckSelections()) { e.cancel = true; ShowSearchError(); } else {  } } }" />
                    <%--<ClientSideEvents ActiveTabChanging="function(s, e){ e.reloadContentOnCallback = true; }" EndCallback="function(s, e){ UpdateMap(); }" />--%>
                    
                    <TabPages>
                        <dx:TabPage Text="<%$ Resources:GlobalResources, Map %>" Name="Map">
                            <ActiveTabStyle Font-Bold="True" Font-Names="Lucida Sans">
                            </ActiveTabStyle>
                            <TabStyle Font-Names="Lucida Sans">
                            </TabStyle>
                            <ContentCollection>
                                <dx:ContentControl runat="server">
                                
                                    <asp:HiddenField ID="hfMapLoaded" runat="server" />
                                    <asp:HiddenField ID="hfAdvisoryClicked" runat="server" />
                                    <asp:HiddenField ID="hfMagicNumber" runat="server" />
                                    <asp:HiddenField ID="AdvisoryNumber" runat="server" />
                                    <asp:HiddenField ID="BaseMapLayer" runat="server" />
                                    
                                    <div id="mapContent">
                                        <div id="mapCaption">
                                            <dx:ASPxLabel runat="server" Font-Names="Lucida Sans" ID="lblMapCaption" ClientInstanceName="lblMapCaption" Height="10px" style="float:left"></dx:ASPxLabel>
                                            <dx:ASPxButton runat="server" ID="btnStreetMap" ClientInstanceName="btnStreetMap" Text="<%$ Resources:GlobalResources, StreetMap %>" ToolTip="<%$ Resources:GlobalResources, StreetMapToolTip %>"  AutoPostBack="false" UseSubmitBehavior="false" CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass" SpriteCssFilePath="~/App_Themes/BlackGlass/{0}/sprite.css" Font-Names="Lucida Sans" Font-Size="0.9em" Height="10px" Width="120px" style="float:right">
                                                <ClientSideEvents Click="function(s, e){ toggleBaseMap(); }" />
                                            </dx:ASPxButton>
                                            <dx:ASPxButton runat="server" ID="btnImageryMap" ClientInstanceName="btnImageryMap" Text="<%$ Resources:GlobalResources, ImageryMap %>" ToolTip="<%$ Resources:GlobalResources, ImageryMapToolTip %>" AutoPostBack="false" UseSubmitBehavior="false" CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass" SpriteCssFilePath="~/App_Themes/BlackGlass/{0}/sprite.css" Font-Names="Lucida Sans" Font-Size="0.9em" Height="10px" Width="120px" style="float:right">
                                                <ClientSideEvents Click="function(s, e){ toggleBaseMap(); }" />
                                            </dx:ASPxButton>
                                        </div>
                                        <div id="mapBodyAdvisory" class="tundra">
                                     
                                            <div id="mainWindow" dojotype="dijit.layout.BorderContainer" design="headline">
                                                <!-- Map Section -->
                                                <div id="map" name="map" dojotype="dijit.layout.ContentPane" region="center" >
                                                </div>

                                                <!-- Identify info window  -->
                                                <div id="idResultsBorder" dojotype="dijit.layout.BorderContainer"> 
                                                    <div id="idResults" title="Identify Results" dojotype="dijit.layout.ContentPane"></div>                                                
                                                </div>
                                                
                                                <!-- Popup info window for query (when no locational results found)  -->
                                                <div id="waterbodyPopUpDiv" dojotype="dijit.layout.BorderContainer">
                                                    <div id="wbTitle" dojotype="dijit.layout.ContentPane" class="title"></div>    
                                                    <div id="wbClose" onclick="hideWaterbodyPopUp();" onmouseover="toggleCloseButton(true);" onmouseout="toggleCloseButton(false);" onmousedown="toggleCloseButton(true);" onmouseup="toggleCloseButton(false);" class="close close-default"></div>
                                                    <div id="wbContent" dojotype="dijit.layout.ContentPane" class="content"></div>
                                                </div>
                                        
                                            </div>
                                        </div>
                                    </div>
                                    
                                </dx:ContentControl>
                            </ContentCollection>
                        </dx:TabPage>
                        
                        <dx:TabPage Text="<%$ Resources:GlobalResources, Report %>" Name="Report">
                            <ActiveTabStyle Font-Bold="True" Font-Names="Lucida Sans">
                            </ActiveTabStyle>
                            <TabStyle Font-Names="Lucida Sans">
                            </TabStyle>
                            <ContentCollection>
                                <dx:ContentControl runat="server">
                                    
                                    <asp:UpdatePanel runat="server" ID="upExport">
                                        <Triggers>
                                            <asp:AsyncPostBackTrigger ControlID="ddlExportFormat" EventName="SelectedIndexChanged" />
                                            <asp:PostBackTrigger ControlID="btnExport" />
                                        </Triggers> 
                                        <ContentTemplate>                                          
                                        
                                            <table id="exportTable">
                                                <tr>
                                                    <td class="instructions" colspan="6">
                                                        <asp:Label ID="lblInstructions" runat="server" Text="<%$ Resources:GlobalResources, TechAdvisoriesReportInstructions %>" Font-Names="Lucida Sans" Font-Size="1em">
                                                        </asp:Label>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="content">
                                                        <asp:Label ID="lblExportFormat" runat="server" Text="<%$ Resources:GlobalResources, ExportFormat %>" Font-Names="Lucida Sans" Font-Size="1em">
                                                        </asp:Label>
                                                    </td>
                                                    <td class="content">
                                                        <dx:ASPxComboBox ID="ddlExportFormat" runat="server" EnableCallbackMode="True" IncrementalFilteringMode="Contains" Font-Names="Lucida Sans" CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass" LoadingPanelImagePosition="Top" ShowShadow="False" SpriteCssFilePath="~/App_Themes/BlackGlass/{0}/sprite.css" AutoPostBack="true" >
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
                                                            <Items>
                                                                <dx:ListEditItem Text="<%$ Resources:GlobalResources, PDF %>" Value="0" Selected="true" />
                                                                <dx:ListEditItem Text="<%$ Resources:GlobalResources, XLS %>" Value="1" />
                                                                <dx:ListEditItem Text="<%$ Resources:GlobalResources, XLSX %>" Value="2" />
                                                            </Items>
                                                        </dx:ASPxComboBox>
                                                    </td>
                                                    <td class="content">
                                                        <dx:ASPxCheckBox ID="chkDetail" runat="server" Text="<%$ Resources:GlobalResources, IncludeDetail %>" Font-Names="Lucida Sans" Checked="true">
                                                        </dx:ASPxCheckBox>
                                                    </td>
                                                    <td class="content">
                                                        <dx:ASPxButton runat="server" ID="btnExport" Text="<%$ Resources:GlobalResources, Export %>" Font-Names="Lucida Sans" OnClick="btnExport_Click" CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass" SpriteCssFilePath="~/App_Themes/BlackGlass/{0}/sprite.css">
                                                            <ClientSideEvents Click="function(s, e){ ShowLoading('mapStatus'); }" LostFocus="function(s, e){ HideLoading('mapStatus'); }"  />
                                                        </dx:ASPxButton>
                                                    </td>
                                                </tr>
                                            </table>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                    
                                    <dx:ASPxGridViewExporter ID="gvxAdvisories" runat="server" GridViewID="gvAdvisories" FileName="<%$ Resources:GlobalResources, ExportFilename %>" Landscape="True">
                                    </dx:ASPxGridViewExporter>
                                    
                                    <dx:ASPxGridView ID="gvAdvisories" runat="server" DataSourceID="odsAdvisories" AutoGenerateColumns="False" KeyFieldName="ADVNUM" Width="100%" CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass" CssClass="dxgvTable" EnableCallBacks="false">
                                        <StylesPager>
                                            <CurrentPageNumber Font-Names="Lucida Sans">
                                            </CurrentPageNumber>
                                            <PageNumber Font-Names="Lucida Sans">
                                            </PageNumber>
                                            <Summary Font-Names="Lucida Sans">
                                            </Summary>
                                        </StylesPager>
                                        <Settings ShowFilterRow="True" />
                                        <StylesEditors>
                                            <CalendarHeader Spacing="1px">
                                            </CalendarHeader>
                                            <ProgressBar Height="25px">
                                            </ProgressBar>
                                        </StylesEditors>
                                        <SettingsDetail ShowDetailRow="true" AllowOnlyOneMasterRowExpanded="true" />
                                        <Styles CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass">
                                            <Header Font-Names="Lucida Sans" Wrap="False" />
                                            <LoadingPanel ImageSpacing="8px">
                                            </LoadingPanel>
                                            <EmptyDataRow Font-Names="Lucida Sans" />
                                            <FilterRowMenu CssClass="AutoFilterMenu" />
                                            <DetailButton BackColor="#3E6B96" Border-BorderColor="White" />
                                        </Styles>
                                        <SettingsLoadingPanel ImagePosition="Top" />
                                        <SettingsPager AlwaysShowPager="false">
                                            <AllButton Text="<%$ Resources:GlobalResources, All %>">
                                            </AllButton>
                                            <NextPageButton Text="<%$ Resources:GlobalResources, Next %>">
                                            </NextPageButton>
                                            <PrevPageButton Text="<%$ Resources:GlobalResources, Prev %>">
                                            </PrevPageButton>
                                        </SettingsPager>
                                        <ImagesFilterControl>
                                            <LoadingPanel Url="~/App_Themes/BlackGlass/Editors/Loading.gif">
                                            </LoadingPanel>
                                        </ImagesFilterControl>
                                        <Images SpriteCssFilePath="~/App_Themes/BlackGlass/{0}/sprite.css">
                                            <DetailCollapsedButton ToolTip="<%$ Resources:GlobalResources, Expand %>" />
                                            <DetailExpandedButton ToolTip="<%$ Resources:GlobalResources, Collapse %>" />
                                            <LoadingPanelOnStatusBar Url="~/App_Themes/BlackGlass/GridView/gvLoadingOnStatusBar.gif">
                                            </LoadingPanelOnStatusBar>
                                            <LoadingPanel Url="~/App_Themes/BlackGlass/GridView/Loading.gif">
                                            </LoadingPanel>
                                        </Images>
                                        <Columns>
                                            <dx:GridViewCommandColumn Caption="<%$ Resources:GlobalResources, FilterCaption %>" VisibleIndex="0">
                                                <ClearFilterButton Text="<%$ Resources:GlobalResources, ClearFilter %>" Visible="True">
                                                </ClearFilterButton>
                                                <HeaderStyle Font-Names="Lucida Sans" />
                                                <CellStyle Font-Names="Lucida Sans">
                                                </CellStyle>
                                            </dx:GridViewCommandColumn>
                                            <dx:GridViewDataTextColumn Caption="<%$ Resources:GlobalResources, ADVNUM_Caption %>" FieldName="ADVNUM" VisibleIndex="1" ToolTip="<%$ Resources:GlobalResources, ADVNUM_ToolTip %>">
                                                <Settings AutoFilterCondition="Contains" ShowFilterRowMenu="True" />
                                                <FilterCellStyle Font-Names="Lucida Sans">
                                                </FilterCellStyle>
                                                <HeaderStyle Font-Names="Lucida Sans" />
                                                <CellStyle Font-Names="Lucida Sans">
                                                </CellStyle>
                                                <DataItemTemplate>
                                                    <asp:LinkButton ID="btnAdvisoryNumber" runat="server" CommandName="Select" CommandArgument='<%# Eval("ADVNUM")%>' OnClick="btnAdvisoryNumber_Click" Text='<%# Eval("ADVNUM")%>' ToolTip="<%$ Resources:GlobalResources, ADVNUM_Instructions %>"></asp:LinkButton>
                                                </DataItemTemplate>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="<%$ Resources:GlobalResources, ADVISORY_Caption %>" FieldName="ADVISORY" VisibleIndex="2" ToolTip="<%$ Resources:GlobalResources, ADVISORY_ToolTip %>">
                                                <Settings AutoFilterCondition="Contains" ShowFilterRowMenu="True" />
                                                <FilterCellStyle Font-Names="Lucida Sans">
                                                </FilterCellStyle>
                                                <HeaderStyle Font-Names="Lucida Sans" />
                                                <CellStyle Font-Names="Lucida Sans">
                                                </CellStyle>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:GlobalResources, ADVISORY_STATUS_Caption %>" FieldName="ADVISORY_STATUS" ToolTip="<%$ Resources:GlobalResources, ADVISORY_STATUS_ToolTip %>" VisibleIndex="3">
                                                <PropertiesComboBox ValueType="System.String" DataSourceID="odsFilterStatus" TextField="ADVISORY_STATUS" IncrementalFilteringMode="StartsWith">
                                                </PropertiesComboBox>
                                                <Settings AutoFilterCondition="BeginsWith" ShowFilterRowMenu="True" />
                                                <FilterCellStyle Font-Names="Lucida Sans">
                                                </FilterCellStyle>
                                                <HeaderStyle Font-Bold="True" Font-Names="Lucida Sans" />
                                                <CellStyle BackColor="#C9D7DC" Font-Bold="true" Font-Names="Lucida Sans" ForeColor="#000">
                                                </CellStyle>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:GlobalResources, STATE_Caption %>" FieldName="STATE" ToolTip="<%$ Resources:GlobalResources, STATE_ToolTip %>" VisibleIndex="4">
                                                <PropertiesComboBox ValueType="System.String" DataSourceID="odsFilterState" TextField="NAME" IncrementalFilteringMode="StartsWith">
                                                </PropertiesComboBox>
                                                <Settings AutoFilterCondition="BeginsWith" ShowFilterRowMenu="True" />
                                                <FilterCellStyle Font-Names="Lucida Sans">
                                                </FilterCellStyle>
                                                <HeaderStyle Font-Names="Lucida Sans" />
                                                <CellStyle Font-Names="Lucida Sans">
                                                </CellStyle>
                                                <DataItemTemplate>
                                                    <dx:ASPxHyperLink ID="lnkStateUrl" runat="server" Text='<% #Eval("STATE") %>' NavigateUrl='<%#Eval("STATEURL")%>' Target="_blank" ToolTip="<%$ Resources:GlobalResources, STATE_Instructions %>" Font-Names="Lucida Sans" Visible='<%#Eval("STATEURL").ToString() <> ""%>'>
                                                    </dx:ASPxHyperLink>
                                                    <dx:ASPxHyperLink ID="lnkNoStateUrl" runat="server" Text='<% #Eval("STATE") %>' NavigateUrl="NoStateSite.aspx" Target="_blank" ToolTip="<%$ Resources:GlobalResources, STATE_Instructions %>" Font-Names="Lucida Sans" Visible='<%#Eval("STATEURL").ToString() = ""%>'>
                                                    </dx:ASPxHyperLink>
                                                </DataItemTemplate>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataTextColumn Caption="<%$ Resources:GlobalResources, STATEURL_Caption %>" FieldName="STATEURL" VisibleIndex="5" Visible="false">
                                                <HeaderStyle Font-Names="Lucida Sans" />
                                                <CellStyle Font-Names="Lucida Sans">
                                                </CellStyle>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:GlobalResources, YEAR_ISSUED_Caption %>" FieldName="YEAR_ISSUED" ToolTip="<%$ Resources:GlobalResources, YEAR_ISSUED_ToolTip %>" VisibleIndex="6">
                                                <PropertiesComboBox ValueType="System.String" DataSourceID="odsFilterYear" TextField="YEAR_ISSUED" IncrementalFilteringMode="StartsWith">
                                                </PropertiesComboBox>
                                                <Settings AutoFilterCondition="Equals" ShowFilterRowMenu="True" />
                                                <FilterCellStyle Font-Names="Lucida Sans">
                                                </FilterCellStyle>
                                                <HeaderStyle Font-Names="Lucida Sans" />
                                                <CellStyle Font-Names="Lucida Sans">
                                                </CellStyle>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataDateColumn Caption="<%$ Resources:GlobalResources, DATE_RESCINDED_Caption %>" FieldName="DATE_RESCINDED" ToolTip="<%$ Resources:GlobalResources, DATE_RESCINDED_ToolTip %>" VisibleIndex="7">
                                                <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy">
                                                </PropertiesDateEdit>
                                                <Settings AutoFilterCondition="Equals" ShowFilterRowMenu="True" />
                                                <FilterCellStyle Font-Names="Lucida Sans">
                                                </FilterCellStyle>
                                                <HeaderStyle Font-Names="Lucida Sans" />
                                                <CellStyle Font-Names="Lucida Sans">
                                                </CellStyle>
                                            </dx:GridViewDataDateColumn>
                                            <dx:GridViewDataDateColumn Caption="<%$ Resources:GlobalResources, CURRENT_AS_OF_Caption %>" FieldName="CURRENT_AS_OF" ToolTip="<%$ Resources:GlobalResources, CURRENT_AS_OF_ToolTip %>" VisibleIndex="8">
                                                <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy">
                                                </PropertiesDateEdit>
                                                <Settings AllowAutoFilter="True" AutoFilterCondition="Equals" 
                                                    ShowFilterRowMenu="True" />
                                                <FilterCellStyle Font-Names="Lucida Sans">
                                                </FilterCellStyle>
                                                <HeaderStyle Font-Names="Lucida Sans" />
                                                <CellStyle Font-Names="Lucida Sans">
                                                </CellStyle>
                                            </dx:GridViewDataDateColumn>
                                            <dx:GridViewDataTextColumn Caption="<%$ Resources:GlobalResources, ADVISORY_EXTENT_Caption %>" FieldName="ADVISORY_EXTENT" VisibleIndex="9" Visible="false">
                                                <HeaderStyle Font-Names="Lucida Sans" />
                                                <CellStyle Font-Names="Lucida Sans">
                                                </CellStyle>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataComboBoxColumn Caption="<%$ Resources:GlobalResources, ADV_TYPE_Caption %>" FieldName="ADV_TYPE" ToolTip="<%$ Resources:GlobalResources, ADV_TYPE_ToolTip %>" VisibleIndex="10">
                                                <PropertiesComboBox ValueType="System.String" DataSourceID="odsFilterAdvisoryType" TextField="ADV_TYPE" IncrementalFilteringMode="StartsWith">
                                                </PropertiesComboBox>
                                                <Settings AutoFilterCondition="BeginsWith" ShowFilterRowMenu="True" />
                                                <FilterCellStyle Font-Names="Lucida Sans">
                                                </FilterCellStyle>
                                                <HeaderStyle Font-Names="Lucida Sans" />
                                                <CellStyle Font-Names="Lucida Sans">
                                                </CellStyle>
                                            </dx:GridViewDataComboBoxColumn>
                                            <dx:GridViewDataTextColumn Caption="<%$ Resources:GlobalResources, ADVISORY_SIZE_Caption %>" FieldName="ADVISORY_SIZE" ToolTip="<%$ Resources:GlobalResources, ADVISORY_SIZE_ToolTip %>" VisibleIndex="11">
                                                <Settings AutoFilterCondition="Contains" ShowFilterRowMenu="True" />
                                                <FilterCellStyle Font-Names="Lucida Sans">
                                                </FilterCellStyle>
                                                <HeaderStyle Font-Names="Lucida Sans" />
                                                <CellStyle Font-Names="Lucida Sans">
                                                </CellStyle>
                                                <DataItemTemplate>
                                                    <asp:Label ID="lblAdvisorySize" runat="server" Text='<% #Eval("ADVISORY_SIZE") %>'></asp:Label>
                                                    <asp:Label ID="lblAdvisorySizeUnit" runat="server" Text='<% #Eval("ADVISORY_SIZE_UNIT") %>'></asp:Label>
                                                </DataItemTemplate>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="<%$ Resources:GlobalResources, ADVISORY_SIZE_Caption %>" FieldName="ADVISORY_SIZE" VisibleIndex="12" Visible="false">
                                                <HeaderStyle Font-Names="Lucida Sans" />
                                                <CellStyle Font-Names="Lucida Sans">
                                                </CellStyle>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="<%$ Resources:GlobalResources, ADVISORY_SIZE_UNIT_Caption %>" FieldName="ADVISORY_SIZE_UNIT" VisibleIndex="13" Visible="false">
                                                <HeaderStyle Font-Names="Lucida Sans" />
                                                <CellStyle Font-Names="Lucida Sans">
                                                </CellStyle>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="<%$ Resources:GlobalResources, ISSUER_Caption %>" FieldName="ISSUER" ToolTip="<%$ Resources:GlobalResources, ISSUER_ToolTip %>" VisibleIndex="14" Visible="false">
                                                <HeaderStyle Font-Names="Lucida Sans" />
                                                <CellStyle Font-Names="Lucida Sans">
                                                </CellStyle>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="<%$ Resources:GlobalResources, CONTACT_NAME_Caption %>" FieldName="CONTACT_NAME" VisibleIndex="15" Visible="false">
                                                <HeaderStyle Font-Names="Lucida Sans" />
                                                <CellStyle Font-Names="Lucida Sans">
                                                </CellStyle>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="<%$ Resources:GlobalResources, EMAIL_Caption %>" FieldName="EMAIL" VisibleIndex="16" Visible="false">
                                                <HeaderStyle Font-Names="Lucida Sans" />
                                                <CellStyle Font-Names="Lucida Sans">
                                                </CellStyle>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="<%$ Resources:GlobalResources, POLLUTANT_Caption %>" FieldName="POLLUTANT" VisibleIndex="17" Visible="false">
                                                <HeaderStyle Font-Names="Lucida Sans" />
                                                <CellStyle Font-Names="Lucida Sans">
                                                </CellStyle>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="<%$ Resources:GlobalResources, SPECIES_Caption %>" FieldName="SPECIES" VisibleIndex="18" Visible="false">
                                                <HeaderStyle Font-Names="Lucida Sans" />
                                                <CellStyle Font-Names="Lucida Sans">
                                                </CellStyle>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="<%$ Resources:GlobalResources, SPECIES_SIZE_Caption %>" FieldName="SPECIES_SIZE" VisibleIndex="19" Visible="false">
                                                <HeaderStyle Font-Names="Lucida Sans" />
                                                <CellStyle Font-Names="Lucida Sans">
                                                </CellStyle>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="<%$ Resources:GlobalResources, POPULATION_Caption %>" FieldName="POPULATION" VisibleIndex="20" Visible="false">
                                                <HeaderStyle Font-Names="Lucida Sans" />
                                                <CellStyle Font-Names="Lucida Sans">
                                                </CellStyle>
                                            </dx:GridViewDataTextColumn>
                                            <dx:GridViewDataTextColumn Caption="<%$ Resources:GlobalResources, ADVISORY_STATUS_Caption %>" FieldName="DETAIL_STATUS" VisibleIndex="21" Visible="false">
                                                <HeaderStyle Font-Names="Lucida Sans" />
                                                <CellStyle Font-Names="Lucida Sans">
                                                </CellStyle>
                                            </dx:GridViewDataTextColumn>
                                        </Columns>
                                        <Templates>
                                            <DetailRow>
                                                <table id="detailTable">
                                                    <tr>
                                                        <td class="content">
                                                            <dx:ASPxGridView ID="gvAdvisoryDetails" runat="server" AutoGenerateColumns="False" DataSourceID="odsAdvisoryDetails2" OnBeforePerformDataSelect="DetailGrid_BeforePerformDataSelect" CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass">
                                                                <Styles CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass">
                                                                    <LoadingPanel ImageSpacing="8px">
                                                                    </LoadingPanel>
                                                                </Styles>
                                                                <SettingsLoadingPanel ImagePosition="Top" />
                                                                <SettingsPager ShowDefaultImages="False" AlwaysShowPager="false" Mode="ShowAllRecords">
                                                                    <AllButton Text="<%$ Resources:GlobalResources, All %>">
                                                                    </AllButton>
                                                                    <NextPageButton Text="<%$ Resources:GlobalResources, Next %>">
                                                                    </NextPageButton>
                                                                    <PrevPageButton Text="<%$ Resources:GlobalResources, Prev %>">
                                                                    </PrevPageButton>
                                                                </SettingsPager>
                                                                <ImagesFilterControl>
                                                                    <LoadingPanel Url="~/App_Themes/BlackGlass/Editors/Loading.gif">
                                                                    </LoadingPanel>
                                                                </ImagesFilterControl>
                                                                <Images SpriteCssFilePath="~/App_Themes/BlackGlass/{0}/sprite.css">
                                                                    <LoadingPanelOnStatusBar Url="~/App_Themes/BlackGlass/GridView/gvLoadingOnStatusBar.gif">
                                                                    </LoadingPanelOnStatusBar>
                                                                    <LoadingPanel Url="~/App_Themes/BlackGlass/GridView/Loading.gif">
                                                                    </LoadingPanel>
                                                                </Images>
                                                                <Columns>
                                                                    <dx:GridViewDataTextColumn Caption="<%$ Resources:GlobalResources, ADVISORY_EXTENT_Caption %>" FieldName="ADVISORY_EXTENT" VisibleIndex="0" ToolTip="<%$ Resources:GlobalResources, ADVISORY_EXTENT_ToolTip %>">
                                                                        <HeaderStyle Font-Names="Lucida Sans" />
                                                                        <CellStyle Font-Names="Lucida Sans" Wrap="True">
                                                                        </CellStyle>
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn Caption="<%$ Resources:GlobalResources, ISSUER_Caption %>" FieldName="ISSUER" VisibleIndex="1" ToolTip="<%$ Resources:GlobalResources, ISSUER_ToolTip %>">
                                                                        <HeaderStyle Font-Names="Lucida Sans" />
                                                                        <CellStyle Font-Names="Lucida Sans">
                                                                        </CellStyle>
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn Caption="<%$ Resources:GlobalResources, CONTACT_NAME_Caption %>" FieldName="NAME" ToolTip="<%$ Resources:GlobalResources, CONTACT_NAME_ToolTip %>" VisibleIndex="2">
                                                                        <HeaderStyle Font-Names="Lucida Sans" />
                                                                        <CellStyle Font-Names="Lucida Sans">
                                                                        </CellStyle>
                                                                        <DataItemTemplate>
                                                                            <dx:ASPxHyperLink ID="lnkContact" runat="server" Text='<% #Eval("NAME") %>' NavigateUrl='<% #Eval("EMAIL","mailto:{0}") %>' ToolTip="<%$ Resources:GlobalResources, CONTACT_NAME_Instructions %>" Font-Names="Lucida Sans">
                                                                            </dx:ASPxHyperLink>
                                                                        </DataItemTemplate>
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn Caption="<%$ Resources:GlobalResources, STATEURL_Caption %>" FieldName="STATEURL" ToolTip="<%$ Resources:GlobalResources, STATEURL_ToolTip %>" VisibleIndex="3">
                                                                        <HeaderStyle Font-Names="Lucida Sans" />
                                                                        <CellStyle Font-Names="Lucida Sans" Wrap="True">
                                                                        </CellStyle>
                                                                        <DataItemTemplate>
                                                                            <dx:ASPxHyperLink ID="lnkStateUrl" runat="server" Text='<% #Eval("STATEURL") %>' NavigateUrl='<% #Eval("STATEURL") %>' Target="_blank" ToolTip="<%$ Resources:GlobalResources, STATE_Instructions %>" Font-Names="Lucida Sans" Visible='<% #Eval("STATEURL").ToString() <> "" %>'>
                                                                            </dx:ASPxHyperLink>
                                                                        </DataItemTemplate>
                                                                    </dx:GridViewDataTextColumn>
                                                                </Columns>
                                                                <StylesPager>
                                                                    <CurrentPageNumber Font-Names="Lucida Sans">
                                                                    </CurrentPageNumber>
                                                                    <PageNumber Font-Names="Lucida Sans">
                                                                    </PageNumber>
                                                                    <Summary Font-Names="Lucida Sans">
                                                                    </Summary>
                                                                </StylesPager>
                                                                <StylesEditors>
                                                                    <CalendarHeader Spacing="1px">
                                                                    </CalendarHeader>
                                                                    <ProgressBar Height="25px">
                                                                    </ProgressBar>
                                                                </StylesEditors>
                                                                <ImagesEditors>
                                                                    <DropDownEditDropDown>
                                                                        <SpriteProperties HottrackedCssClass="dxEditors_edtDropDownHover_BlackGlass" PressedCssClass="dxEditors_edtDropDownPressed_BlackGlass" />
                                                                    </DropDownEditDropDown>
                                                                    <SpinEditIncrement>
                                                                        <SpriteProperties HottrackedCssClass="dxEditors_edtSpinEditIncrementImageHover_BlackGlass" PressedCssClass="dxEditors_edtSpinEditIncrementImagePressed_BlackGlass" />
                                                                    </SpinEditIncrement>
                                                                    <SpinEditDecrement>
                                                                        <SpriteProperties HottrackedCssClass="dxEditors_edtSpinEditDecrementImageHover_BlackGlass" PressedCssClass="dxEditors_edtSpinEditDecrementImagePressed_BlackGlass" />
                                                                    </SpinEditDecrement>
                                                                    <SpinEditLargeIncrement>
                                                                        <SpriteProperties HottrackedCssClass="dxEditors_edtSpinEditLargeIncImageHover_BlackGlass" PressedCssClass="dxEditors_edtSpinEditLargeIncImagePressed_BlackGlass" />
                                                                    </SpinEditLargeIncrement>
                                                                    <SpinEditLargeDecrement>
                                                                        <SpriteProperties HottrackedCssClass="dxEditors_edtSpinEditLargeDecImageHover_BlackGlass" PressedCssClass="dxEditors_edtSpinEditLargeDecImagePressed_BlackGlass" />
                                                                    </SpinEditLargeDecrement>
                                                                </ImagesEditors>
                                                            </dx:ASPxGridView>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="content">
                                                            <dx:ASPxGridView ID="gvAdvisorySpecies" runat="server" AutoGenerateColumns="False" DataSourceID="odsAdvisoryDetails" OnBeforePerformDataSelect="DetailGrid_BeforePerformDataSelect" CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass">
                                                                <Styles CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass">
                                                                    <LoadingPanel ImageSpacing="8px">
                                                                    </LoadingPanel>
                                                                </Styles>
                                                                <SettingsLoadingPanel ImagePosition="Top" />
                                                                <Settings ShowFilterRow="True" />
                                                                <SettingsPager ShowDefaultImages="False" AlwaysShowPager="false" Mode="ShowAllRecords">
                                                                    <AllButton Text="<%$ Resources:GlobalResources, All %>">
                                                                    </AllButton>
                                                                    <NextPageButton Text="<%$ Resources:GlobalResources, Next %>">
                                                                    </NextPageButton>
                                                                    <PrevPageButton Text="<%$ Resources:GlobalResources, Prev %>">
                                                                    </PrevPageButton>
                                                                </SettingsPager>
                                                                <ImagesFilterControl>
                                                                    <LoadingPanel Url="~/App_Themes/BlackGlass/Editors/Loading.gif">
                                                                    </LoadingPanel>
                                                                </ImagesFilterControl>
                                                                <Images SpriteCssFilePath="~/App_Themes/BlackGlass/{0}/sprite.css">
                                                                    <LoadingPanelOnStatusBar Url="~/App_Themes/BlackGlass/GridView/gvLoadingOnStatusBar.gif">
                                                                    </LoadingPanelOnStatusBar>
                                                                    <LoadingPanel Url="~/App_Themes/BlackGlass/GridView/Loading.gif">
                                                                    </LoadingPanel>
                                                                </Images>
                                                                <Columns>
                                                                    <dx:GridViewCommandColumn Caption="<%$ Resources:GlobalResources, FilterCaption %>" VisibleIndex="0">
                                                                        <ClearFilterButton Text="<%$ Resources:GlobalResources, ClearFilter %>" Visible="True">
                                                                        </ClearFilterButton>
                                                                        <HeaderStyle Font-Names="Lucida Sans" />
                                                                        <CellStyle Font-Names="Lucida Sans">
                                                                        </CellStyle>
                                                                    </dx:GridViewCommandColumn>
                                                                    <dx:GridViewDataTextColumn Caption="<%$ Resources:GlobalResources, POLLUTANT_Caption %>" FieldName="POLLUTANT" ToolTip="<%$ Resources:GlobalResources, POLLUTANT_ToolTip %>" VisibleIndex="1">
                                                                        <HeaderStyle Font-Names="Lucida Sans" />
                                                                        <CellStyle Font-Names="Lucida Sans">
                                                                        </CellStyle>
                                                                        <Settings AutoFilterCondition="Contains" ShowFilterRowMenu="True" />
                                                                        <FilterCellStyle Font-Names="Lucida Sans">
                                                                        </FilterCellStyle>
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn Caption="<%$ Resources:GlobalResources, SPECIES_Caption %>" FieldName="SPECIES" ToolTip="<%$ Resources:GlobalResources, SPECIES_ToolTip %>" VisibleIndex="2">
                                                                        <HeaderStyle Font-Names="Lucida Sans" />
                                                                        <CellStyle Font-Names="Lucida Sans">
                                                                        </CellStyle>
                                                                        <Settings AutoFilterCondition="Contains" ShowFilterRowMenu="True" />
                                                                        <FilterCellStyle Font-Names="Lucida Sans">
                                                                        </FilterCellStyle>
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn Caption="<%$ Resources:GlobalResources, SPECIES_SIZE_Caption %>" FieldName="SPECIES_SIZE" ToolTip="<%$ Resources:GlobalResources, SPECIES_SIZE_ToolTip %>" VisibleIndex="3">
                                                                        <HeaderStyle Font-Names="Lucida Sans" />
                                                                        <CellStyle Font-Names="Lucida Sans">
                                                                        </CellStyle>
                                                                        <Settings AllowAutoFilter="False" />
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn Caption="<%$ Resources:GlobalResources, POPULATION_Caption %>" FieldName="POPULATION" ToolTip="<%$ Resources:GlobalResources, POPULATION_ToolTip %>" VisibleIndex="4">
                                                                        <HeaderStyle Font-Names="Lucida Sans" />
                                                                        <CellStyle Font-Names="Lucida Sans">
                                                                        </CellStyle>
                                                                        <Settings AutoFilterCondition="Contains" ShowFilterRowMenu="True" />
                                                                        <FilterCellStyle Font-Names="Lucida Sans">
                                                                        </FilterCellStyle>
                                                                    </dx:GridViewDataTextColumn>
                                                                    <dx:GridViewDataTextColumn Caption="<%$ Resources:GlobalResources, ADVISORY_STATUS_Caption %>" FieldName="STATUS" ToolTip="<%$ Resources:GlobalResources, ADVISORY_STATUS_ToolTip %>" VisibleIndex="5">
                                                                        <HeaderStyle Font-Names="Lucida Sans" />
                                                                        <CellStyle Font-Names="Lucida Sans">
                                                                        </CellStyle>
                                                                        <Settings AutoFilterCondition="Contains" ShowFilterRowMenu="True" />
                                                                        <FilterCellStyle Font-Names="Lucida Sans">
                                                                        </FilterCellStyle>
                                                                    </dx:GridViewDataTextColumn>
                                                                </Columns>
                                                                <StylesPager>
                                                                    <CurrentPageNumber Font-Names="Lucida Sans">
                                                                    </CurrentPageNumber>
                                                                    <PageNumber Font-Names="Lucida Sans">
                                                                    </PageNumber>
                                                                    <Summary Font-Names="Lucida Sans">
                                                                    </Summary>
                                                                </StylesPager>
                                                                <StylesEditors>
                                                                    <CalendarHeader Spacing="1px">
                                                                    </CalendarHeader>
                                                                    <ProgressBar Height="25px">
                                                                    </ProgressBar>
                                                                </StylesEditors>
                                                                <ImagesEditors>
                                                                    <DropDownEditDropDown>
                                                                        <SpriteProperties HottrackedCssClass="dxEditors_edtDropDownHover_BlackGlass" PressedCssClass="dxEditors_edtDropDownPressed_BlackGlass" />
                                                                    </DropDownEditDropDown>
                                                                    <SpinEditIncrement>
                                                                        <SpriteProperties HottrackedCssClass="dxEditors_edtSpinEditIncrementImageHover_BlackGlass" PressedCssClass="dxEditors_edtSpinEditIncrementImagePressed_BlackGlass" />
                                                                    </SpinEditIncrement>
                                                                    <SpinEditDecrement>
                                                                        <SpriteProperties HottrackedCssClass="dxEditors_edtSpinEditDecrementImageHover_BlackGlass" PressedCssClass="dxEditors_edtSpinEditDecrementImagePressed_BlackGlass" />
                                                                    </SpinEditDecrement>
                                                                    <SpinEditLargeIncrement>
                                                                        <SpriteProperties HottrackedCssClass="dxEditors_edtSpinEditLargeIncImageHover_BlackGlass" PressedCssClass="dxEditors_edtSpinEditLargeIncImagePressed_BlackGlass" />
                                                                    </SpinEditLargeIncrement>
                                                                    <SpinEditLargeDecrement>
                                                                        <SpriteProperties HottrackedCssClass="dxEditors_edtSpinEditLargeDecImageHover_BlackGlass" PressedCssClass="dxEditors_edtSpinEditLargeDecImagePressed_BlackGlass" />
                                                                    </SpinEditLargeDecrement>
                                                                </ImagesEditors>
                                                            </dx:ASPxGridView>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </DetailRow>
                                        </Templates>
                                        <ImagesEditors>
                                            <DropDownEditDropDown>
                                                <SpriteProperties HottrackedCssClass="dxEditors_edtDropDownHover_BlackGlass" PressedCssClass="dxEditors_edtDropDownPressed_BlackGlass" />
                                            </DropDownEditDropDown>
                                            <SpinEditIncrement>
                                                <SpriteProperties HottrackedCssClass="dxEditors_edtSpinEditIncrementImageHover_BlackGlass" PressedCssClass="dxEditors_edtSpinEditIncrementImagePressed_BlackGlass" />
                                            </SpinEditIncrement>
                                            <SpinEditDecrement>
                                                <SpriteProperties HottrackedCssClass="dxEditors_edtSpinEditDecrementImageHover_BlackGlass" PressedCssClass="dxEditors_edtSpinEditDecrementImagePressed_BlackGlass" />
                                            </SpinEditDecrement>
                                            <SpinEditLargeIncrement>
                                                <SpriteProperties HottrackedCssClass="dxEditors_edtSpinEditLargeIncImageHover_BlackGlass" PressedCssClass="dxEditors_edtSpinEditLargeIncImagePressed_BlackGlass" />
                                            </SpinEditLargeIncrement>
                                            <SpinEditLargeDecrement>
                                                <SpriteProperties HottrackedCssClass="dxEditors_edtSpinEditLargeDecImageHover_BlackGlass" PressedCssClass="dxEditors_edtSpinEditLargeDecImagePressed_BlackGlass" />
                                            </SpinEditLargeDecrement>
                                        </ImagesEditors>
                                    </dx:ASPxGridView>
                                    <br />
                                                                        
                                    <asp:ObjectDataSource ID="odsAdvisories" runat="server" 
                                        SelectMethod="AdvisoryList" TypeName="NLFA.OracleDataProvider">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="hfMagicNumber" Name="sessionId" PropertyName="Value" Type="String" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlEpaRegion" Name="region" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlState" Name="state" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlWaterbody" Name="waterbody" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlAdvisoryType" Name="advisoryType" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlFishSpecies" Name="species" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlPollutant" Name="pollutant" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlPopulation" Name="population" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlStatus" Name="status" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlStartYear" Name="startYear" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlEndYear" Name="endYear" PropertyName="SelectedItem.Value" Type="String" />
                                        </SelectParameters>
                                    </asp:ObjectDataSource>
                                    
                                    <asp:ObjectDataSource ID="odsExportAdvisories" runat="server" 
                                        SelectMethod="ExportAdvisoryList" TypeName="NLFA.OracleDataProvider">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="pnlQuery$ddlEpaRegion" Name="region" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlState" Name="state" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlWaterbody" Name="waterbody" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlAdvisoryType" Name="advisoryType" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlFishSpecies" Name="species" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlPollutant" Name="pollutant" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlPopulation" Name="population" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlStatus" Name="status" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlStartYear" Name="startYear" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlEndYear" Name="endYear" PropertyName="SelectedItem.Value" Type="String" />
                                        </SelectParameters>
                                    </asp:ObjectDataSource>
                                    
                                    <asp:ObjectDataSource ID="odsAdvisoryDetails" runat="server" 
                                        SelectMethod="AdvisoryDetails" TypeName="NLFA.OracleDataProvider">
                                        <SelectParameters>
                                            <asp:SessionParameter Name="advisoryNumber" Type="Int32" SessionField="AdvisoryNumber" />
                                        </SelectParameters>
                                    </asp:ObjectDataSource>
                                    
                                    <asp:ObjectDataSource ID="odsAdvisoryDetails2" runat="server" 
                                        SelectMethod="AdvisoryDetails2" TypeName="NLFA.OracleDataProvider">
                                        <SelectParameters>
                                            <asp:SessionParameter Name="advisoryNumber" Type="Int32" SessionField="AdvisoryNumber" />
                                        </SelectParameters>
                                    </asp:ObjectDataSource>
                                    
                                    <asp:ObjectDataSource ID="odsFilterStatus" runat="server" SelectMethod="StatusList" TypeName="NLFA.OracleDataProvider" EnableCaching="True" CacheDuration="600" CacheExpirationPolicy="Sliding">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="pnlQuery$ddlEpaRegion" Name="region" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlState" Name="state" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlWaterbody" Name="waterbody" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlAdvisoryType" Name="advisoryType" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlFishSpecies" Name="species" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlPollutant" Name="pollutant" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlPopulation" Name="population" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlStartYear" Name="startYear" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlEndYear" Name="endYear" PropertyName="SelectedItem.Value" Type="String" />
                                        </SelectParameters>
                                    </asp:ObjectDataSource>
                                    
                                    <asp:ObjectDataSource ID="odsFilterState" runat="server" SelectMethod="StateList" TypeName="NLFA.OracleDataProvider" EnableCaching="True" CacheDuration="600" CacheExpirationPolicy="Sliding">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="pnlQuery$ddlEpaRegion" Name="region" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlWaterbody" Name="waterbody" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlAdvisoryType" Name="advisoryType" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlFishSpecies" Name="species" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlPollutant" Name="pollutant" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlPopulation" Name="population" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlStatus" Name="status" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlStartYear" Name="startYear" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlEndYear" Name="endYear" PropertyName="SelectedItem.Value" Type="String" />
                                        </SelectParameters>
                                    </asp:ObjectDataSource>
                                    
                                    <asp:ObjectDataSource ID="odsFilterYear" runat="server" SelectMethod="YearList" TypeName="NLFA.OracleDataProvider" EnableCaching="True" CacheDuration="600" CacheExpirationPolicy="Sliding">
                                        <SelectParameters>
                                             <asp:ControlParameter ControlID="pnlQuery$ddlEpaRegion" Name="region" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlState" Name="state" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlWaterbody" Name="waterbody" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlAdvisoryType" Name="advisoryType" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlFishSpecies" Name="species" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlPollutant" Name="pollutant" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlPopulation" Name="population" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlStatus" Name="status" PropertyName="SelectedItem.Value" Type="String" />
                                        </SelectParameters>
                                    </asp:ObjectDataSource>
                                    
                                    <asp:ObjectDataSource ID="odsFilterAdvisoryType" runat="server" SelectMethod="AdvisoryTypeList" TypeName="NLFA.OracleDataProvider" EnableCaching="True" CacheDuration="600" CacheExpirationPolicy="Sliding">
                                        <SelectParameters>
                                            <asp:ControlParameter ControlID="pnlQuery$ddlEpaRegion" Name="region" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlState" Name="state" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlWaterbody" Name="waterbody" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlFishSpecies" Name="species" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlPollutant" Name="pollutant" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlPopulation" Name="population" PropertyName="SelectedItem.Value" Type="Int32" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlStatus" Name="status" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlStartYear" Name="startYear" PropertyName="SelectedItem.Value" Type="String" />
                                            <asp:ControlParameter ControlID="pnlQuery$ddlEndYear" Name="endYear" PropertyName="SelectedItem.Value" Type="String" />
                                        </SelectParameters>
                                    </asp:ObjectDataSource>
                                    
                                </dx:ContentControl>
                            </ContentCollection>
                        </dx:TabPage>
                    </TabPages>
                </dx:ASPxPageControl>
            </td>
        </tr>
    </table>
</asp:Content>
