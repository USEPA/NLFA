<%@ page language="VB" autoeventwireup="false" inherits="NLFA.AdvisoryDetails, App_Web_advisorydetails.aspx.cdcab7d2" title="<%$ Resources:GlobalResources, AdvisoryDetailsPageTitle %>" enableEventValidation="false" viewStateEncryptionMode="Never" %>

<%@ Register Assembly="DevExpress.Web.ASPxGridView.v10.1, Version=10.1.9.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web.ASPxGridView" TagPrefix="dx" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link rel="stylesheet" type="text/css" href="css/layout.css" />
  <!-- Google Tag Manager -->
  <script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({"gtm.start":new Date().getTime(),event:"gtm.js"});var f=d.getElementsByTagName(s)[0],j=d.createElement(s),dl=l!="dataLayer"?"&l="+l:"";j.async=true;j.src="//www.googletagmanager.com/gtm.js?id="+i+dl;f.parentNode.insertBefore(j,f);})(window,document,"script","dataLayer","GTM-L8ZB");</script>
  <!-- End Google Tag Manager -->  
</head>
<body id="AdvisoryDetails">
    <form id="frmAdvisoryDetails" runat="server">
        <h1>
            <asp:Literal ID="litTitle" runat="server" Text="<%$ Resources:GlobalResources, AdvisoryDetailsTitle %>"></asp:Literal>
        </h1>
        <h2>
            <asp:Literal ID="litState" runat="server"></asp:Literal> - <span class="highlight"><asp:Literal ID="litWaterbody" runat="server"></asp:Literal></span>
        </h2>
        <hr />
        <table class="summary">
            <tr>
                <td class="heading">
                    <asp:Literal ID="litAdvisoryCaption" runat="server" Text="<%$ Resources:GlobalResources, ADVISORY_Caption %>"></asp:Literal>:
                </td>
                <td>
                    <asp:Literal ID="litAdvisory" runat="server"></asp:Literal>
                </td>
            </tr>
            <tr>
                <td class="heading">
                    <asp:Literal ID="litAdvNumCaption" runat="server" Text="<%$ Resources:GlobalResources, ADVNUM_Caption %>"></asp:Literal>:
                </td>
                <td>
                    <asp:Literal ID="litAdvNum" runat="server"></asp:Literal>
                </td>
            </tr>
            <tr>
                <td class="heading">
                    <asp:Literal ID="litAdvisoryStatusCaption" runat="server" Text="<%$ Resources:GlobalResources, ADVISORY_STATUS_Caption %>"></asp:Literal>:
                </td>
                <td>
                    <asp:Literal ID="litAdvisoryStatus" runat="server"></asp:Literal>
                </td>
            </tr>
            <tr>
                <td class="heading">
                    <asp:Literal ID="litYearIssuedCaption" runat="server" Text="<%$ Resources:GlobalResources, YEAR_ISSUED_Caption %>"></asp:Literal>:
                </td>
                <td>
                    <asp:Literal ID="litYearIssued" runat="server"></asp:Literal>
                </td>
            </tr>
            <tr>
                <td class="heading">
                    <asp:Literal ID="litAdvisoryExtentCaption" runat="server" Text="<%$ Resources:GlobalResources, ADVISORY_EXTENT_Caption %>"></asp:Literal>:
                </td>
                <td>
                    <asp:Literal ID="litAdvisoryExtent" runat="server"></asp:Literal>
                </td>
            </tr>
            <tr>
                <td class="heading">
                    <asp:Literal ID="litAdvTypeCaption" runat="server" Text="<%$ Resources:GlobalResources, ADV_TYPE_Caption %>"></asp:Literal>:
                </td>
                <td>
                    <asp:Literal ID="litAdvType" runat="server"></asp:Literal>
                </td>
            </tr>
            <tr>
                <td class="heading">
                    <asp:Literal ID="litAdvisorySizeCaption" runat="server" Text="<%$ Resources:GlobalResources, ADVISORY_SIZE_Caption %>"></asp:Literal>
                </td>
                <td>
                    <asp:Literal ID="litAdvisorySize" runat="server"></asp:Literal>
                </td>
            </tr>
            <tr>
                <td class="heading">
                    <asp:Literal ID="litIssuerCaption" runat="server" Text="<%$ Resources:GlobalResources, ISSUER_Caption %>"></asp:Literal>:
                </td>
                <td>
                    <asp:Literal ID="litIssuer" runat="server"></asp:Literal>
                </td>
            </tr>
            <tr>
                <td class="heading">
                    <asp:Literal ID="litStateUrlCaption" runat="server" Text="<%$ Resources:GlobalResources, STATEURL_Caption %>"></asp:Literal>:
                </td>
                <td>
                    <asp:Literal ID="litStateUrl" runat="server"></asp:Literal>
                </td>
            </tr>
            <tr>
                <td class="heading">
                    <asp:Literal ID="litContactNameCaption" runat="server" Text="<%$ Resources:GlobalResources, CONTACT_NAME_Caption %>"></asp:Literal>:
                </td>
                <td>
                    <asp:Literal ID="litContactName" runat="server"></asp:Literal>
                </td>
            </tr>
            <tr>
                <td class="heading">
                    <asp:Literal ID="litEmailCaption" runat="server" Text="<%$ Resources:GlobalResources, EMAIL_Caption %>"></asp:Literal>:
                </td>
                <td>
                    <asp:Literal ID="litEmail" runat="server"></asp:Literal>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <b>
                        <asp:Literal ID="litSafeEatingCaption" runat="server" Text="<%$ Resources:GlobalResources, SAFE_EATING_Caption %>"></asp:Literal>
                    </b>
                    &nbsp;
                    <asp:Literal ID="litSafeEating" runat="server"></asp:Literal>
                </td>
            </tr>
        </table>
        <p>
            <asp:Literal ID="litDescription" runat="server" Text="<%$ Resources:GlobalResources, AdvisoryDetailsDescription %>"></asp:Literal>
        </p>
        <p>
            <i>
                <asp:Literal ID="litSafeEatingDescripotion" runat="server" Text="<%$ Resources:GlobalResources, SafeEatingDescription %>"></asp:Literal>
            </i>
        </p>
        <h2>
            <asp:Literal ID="litDetails" runat="server"></asp:Literal>
        </h2>
        <dx:ASPxGridView ID="gvAdvisoryDetails" runat="server" AutoGenerateColumns="False" DataSourceID="odsAdvisoryDetails" CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass" Width="99%">
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
        <asp:ObjectDataSource ID="odsAdvisoryDetails" runat="server" 
            SelectMethod="AdvisoryDetails" TypeName="NLFA.OracleDataProvider">
            <SelectParameters>
                <asp:QueryStringParameter Name="advisoryNumber" QueryStringField="ADVNUM" Type="Int32" />
            </SelectParameters>
        </asp:ObjectDataSource>
    </form>

  <!-- Google Tag Manager -->
  <noscript><iframe src="//www.googletagmanager.com/ns.html?id=GTM-L8ZB" height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
  <!-- End Google Tag Manager -->  
  
</body>
</html>
