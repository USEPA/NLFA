<%@ page language="VB" autoeventwireup="false" inherits="NLFA.FishTissueDetails, App_Web_fishtissuedetails.aspx.cdcab7d2" enableEventValidation="false" viewStateEncryptionMode="Never" %>

<%@ Register Assembly="DevExpress.Web.ASPxGridView.v10.1, Version=10.1.9.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web.ASPxGridView" TagPrefix="dx" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
    <link rel="stylesheet" type="text/css" href="css/layout.css" />
  <!-- Google Tag Manager -->
  <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({"gtm.start":new Date().getTime(),event:"gtm.js"});var f=d.getElementsByTagName(s)[0],j=d.createElement(s),dl=l!="dataLayer"?"&l="+l:"";j.async=true;j.src="//www.googletagmanager.com/gtm.js?id="+i+dl;f.parentNode.insertBefore(j,f);})(window,document,"script","dataLayer","GTM-L8ZB");</script>
  <!-- End Google Tag Manager -->  
</head>
<body id="AdvisoryDetails">
    <form id="frmAdvisoryDetails" runat="server">
        <h1>
            <asp:Literal ID="litTitle" runat="server" Text="<%$ Resources:GlobalResources, FishTissueDetailsTitle %>"></asp:Literal>
        </h1>
        <h2>
            <asp:Literal ID="litState" runat="server"></asp:Literal> - <span class="highlight"><asp:Literal ID="litWaterbody" runat="server"></asp:Literal></span>
        </h2>
        <hr />
        <table class="summary">
            <tr>
                <td class="heading">
                    <asp:Literal ID="litStationIdCaption" runat="server" Text="<%$ Resources:GlobalResources, STATION_ID_Caption %>"></asp:Literal>:
                </td>
                <td>
                    <asp:Literal ID="litStationId" runat="server"></asp:Literal>
                </td>
            </tr>
            <tr>
                <td class="heading">
                    <asp:Literal ID="litSitenameCaption" runat="server" Text="<%$ Resources:GlobalResources, SITENAME_Caption %>"></asp:Literal>:
                </td>
                <td>
                    <asp:Literal ID="litSitename" runat="server"></asp:Literal>
                </td>
            </tr>
            <tr>
                <td class="heading">
                    <asp:Literal ID="litLocationCaption" runat="server" Text="<%$ Resources:GlobalResources, LOCATION_Caption %>"></asp:Literal>:
                </td>
                <td>
                    <asp:Literal ID="litLocation" runat="server"></asp:Literal>
                </td>
            </tr>
            <tr>
                <td class="heading">
                    <asp:Literal ID="litLatDdCaption" runat="server" Text="<%$ Resources:GlobalResources, LAT_DD_Caption %>"></asp:Literal>:
                </td>
                <td>
                    <asp:Literal ID="litLatDd" runat="server"></asp:Literal>
                </td>
            </tr>
            <tr>
                <td class="heading">
                    <asp:Literal ID="litLongDdCaption" runat="server" Text="<%$ Resources:GlobalResources, LONG_DD_Caption %>"></asp:Literal>:
                </td>
                <td>
                    <asp:Literal ID="litLongDd" runat="server"></asp:Literal>
                </td>
            </tr>
            <tr>
                <td class="heading">
                    <asp:Literal ID="litSampleDateRecentCaption" runat="server" Text="<%$ Resources:GlobalResources, SAMPLEDATE_RECENT_Caption %>"></asp:Literal>:
                </td>
                <td>
                    <asp:Literal ID="litSampleDateRecent" runat="server"></asp:Literal>
                </td>
            </tr>
        </table>
        <p>
            <asp:Literal ID="litDescription" runat="server" Text="<%$ Resources:GlobalResources, FishTissueDetailsDescription %>"></asp:Literal>
        </p>
        <h2>
            <asp:Literal ID="litDetails" runat="server"></asp:Literal>
        </h2>
        <dx:ASPxGridView ID="gvTissueDetails" runat="server" AutoGenerateColumns="False" DataSourceID="odsTissueDetails" CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass">
            <Styles CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass">
                <LoadingPanel ImageSpacing="8px">
                </LoadingPanel>
                <Header Wrap="True" />
                <FilterRowMenu CssClass="AutoFilterMenu"  />
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
                <dx:GridViewDataTextColumn Caption="Sample ID" FieldName="SAMPLE_ID" ToolTip="Unique identifier given to each sample in the database" VisibleIndex="1">
                    <HeaderStyle Font-Names="Lucida Sans" />
                    <CellStyle Font-Names="Lucida Sans">
                    </CellStyle>
                    <Settings AllowAutoFilter="False" />
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataDateColumn Caption="Sample date" FieldName="SAMPLEDATE" ToolTip="Date sample was taken in the field" VisibleIndex="2">
                    <PropertiesDateEdit DisplayFormatString="MM/dd/yyyy"></PropertiesDateEdit>
                    <HeaderStyle Font-Names="Lucida Sans" />
                    <CellStyle Font-Names="Lucida Sans" Wrap="True">
                    </CellStyle>
                    <Settings AutoFilterCondition="GreaterOrEqual" ShowFilterRowMenu="True" />
                    <FilterCellStyle Font-Names="Lucida Sans">
                    </FilterCellStyle>
                </dx:GridViewDataDateColumn>
                <dx:GridViewDataTextColumn Caption="Species" FieldName="SPECIES" ToolTip="Fish species" VisibleIndex="3">
                    <HeaderStyle Font-Names="Lucida Sans" />
                    <CellStyle Font-Names="Lucida Sans">
                    </CellStyle>
                    <Settings AutoFilterCondition="Contains" ShowFilterRowMenu="True" />
                    <FilterCellStyle Font-Names="Lucida Sans">
                    </FilterCellStyle>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn Caption="Number of fish" FieldName="NUM_FISH" ToolTip="Number of fish in this sample" VisibleIndex="4">
                    <HeaderStyle Font-Names="Lucida Sans" />
                    <CellStyle Font-Names="Lucida Sans" Wrap="True">
                    </CellStyle>
                    <Settings AllowAutoFilter="False" />
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn Caption="Sample type" FieldName="SMPL_TYPE" ToolTip="Type of sample (for example, fillet or whole fish)" VisibleIndex="5">
                    <HeaderStyle Font-Names="Lucida Sans" />
                    <CellStyle Font-Names="Lucida Sans" Wrap="True">
                    </CellStyle>
                    <Settings AllowAutoFilter="False" />
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn Caption="Length" FieldName="LENGTH" ToolTip="Fish length and associated unit of measurement" VisibleIndex="6">
                    <HeaderStyle Font-Names="Lucida Sans" />
                    <CellStyle Font-Names="Lucida Sans" Wrap="False">
                    </CellStyle>
                    <Settings AllowAutoFilter="False" />
                    <DataItemTemplate>
                        <asp:Label ID="lblLength" runat="server" Text='<% #Eval("LENGTH") %>'></asp:Label>
                        <asp:Label ID="lblLengthUnit" runat="server" Text='<% #Eval("LENGTHUNIT") %>'></asp:Label>
                    </DataItemTemplate>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn Caption="Weight" FieldName="WEIGHT" ToolTip="Fish weight and associated unit of measurement" VisibleIndex="7">
                    <HeaderStyle Font-Names="Lucida Sans" />
                    <CellStyle Font-Names="Lucida Sans" Wrap="False">
                    </CellStyle>
                    <Settings AllowAutoFilter="False" />
                    <DataItemTemplate>
                        <asp:Label ID="lblWeight" runat="server" Text='<% #Eval("WEIGHT") %>'></asp:Label>
                        <asp:Label ID="lblWeightUnit" runat="server" Text='<% #Eval("WEIGHTUNIT") %>'></asp:Label>
                    </DataItemTemplate>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn Caption="Pollutant" FieldName="PARM_TEXT" ToolTip="Name of the pollutant for which this sample was tested" VisibleIndex="8">
                    <HeaderStyle Font-Names="Lucida Sans" />
                    <CellStyle Font-Names="Lucida Sans">
                    </CellStyle>
                    <Settings AutoFilterCondition="Contains" ShowFilterRowMenu="True" />
                    <FilterCellStyle Font-Names="Lucida Sans">
                    </FilterCellStyle>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn Caption="Result" FieldName="RESULTNUM" ToolTip="Result value and associated unit of measurement" VisibleIndex="9">
                    <HeaderStyle Font-Names="Lucida Sans" />
                    <CellStyle Font-Names="Lucida Sans" Wrap="False">
                    </CellStyle>
                    <Settings AllowAutoFilter="False" />
                    <DataItemTemplate>
                        <asp:Label ID="lblResult" runat="server" Text='<% #Eval("RESULTNUM") %>'></asp:Label>
                        <asp:Label ID="lblResultUnit" runat="server" Text='<% #Eval("RESULTUNIT") %>'></asp:Label>
                    </DataItemTemplate>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn Caption="Data qualifier desc." FieldName="DQDESCRIPTION" ToolTip="Data qualifier description, including data qualifier code" VisibleIndex="10">
                    <HeaderStyle Font-Names="Lucida Sans" />
                    <CellStyle Font-Names="Lucida Sans">
                    </CellStyle>
                    <Settings AllowAutoFilter="False" />
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn Caption="Detection limit info." FieldName="DL_INFO" ToolTip="Detection limit information, if available" VisibleIndex="11">
                    <HeaderStyle Font-Names="Lucida Sans" />
                    <CellStyle Font-Names="Lucida Sans">
                    </CellStyle>
                    <Settings AllowAutoFilter="False" />
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
        <asp:ObjectDataSource ID="odsTissueDetails" runat="server" 
            SelectMethod="TissueDetails" TypeName="NLFA.OracleDataProvider">
            <SelectParameters>
                <asp:QueryStringParameter Name="stationId" QueryStringField="STATION_ID" Type="String" />
            </SelectParameters>
        </asp:ObjectDataSource>
    </form>

  <!-- Google Tag Manager -->
  <noscript><iframe src="//www.googletagmanager.com/ns.html?id=GTM-L8ZB" height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
  <!-- End Google Tag Manager -->  
  
</body>
</html>