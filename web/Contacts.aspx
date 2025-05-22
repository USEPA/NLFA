<%@ page title="<%$ Resources:GlobalResources, ContactsPageTitle %>" language="VB" masterpagefile="~/Site.master" autoeventwireup="false" inherits="NLFA.Contacts, App_Web_contacts.aspx.cdcab7d2" enableEventValidation="false" viewStateEncryptionMode="Never" %>

<%@ Register Assembly="DevExpress.Web.ASPxEditors.v10.1, Version=10.1.9.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web.ASPxEditors" TagPrefix="dx" %>

<%@ Register Assembly="DevExpress.Web.ASPxGridView.v10.1, Version=10.1.9.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web.ASPxGridView" TagPrefix="dx" %>

<asp:Content ID="cStyles" ContentPlaceHolderID="cpStyles" Runat="Server">
</asp:Content>
<asp:Content ID="cScripts" ContentPlaceHolderID="cpScripts" Runat="Server">
</asp:Content>
<asp:Content ID="cPageTitleBreadcrumb" ContentPlaceHolderID="cpPageTitleBreadcrumb" Runat="Server">
    <asp:Label ID="lblPageTitleBreadcrumb" runat="server" Text="<%$ Resources:GlobalResources, ContactsTitle %>"></asp:Label>
</asp:Content>
<asp:Content ID="cPageTitle" ContentPlaceHolderID="cpPageTitle" Runat="Server">
    <asp:Label ID="lblPageTitle" runat="server" Text="<%$ Resources:GlobalResources, ContactsTitle %>"></asp:Label>
</asp:Content>
<asp:Content ID="cContent" ContentPlaceHolderID="cpContent" Runat="Server">
    <dx:ASPxGridView ID="gvContacts" runat="server" AutoGenerateColumns="False" DataSourceID="odsContacts" CssFilePath="~/App_Themes/BlackGlass/{0}/styles.css" CssPostfix="BlackGlass" Width="99%">
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
                <dx:GridViewDataTextColumn Caption="<%$ Resources:GlobalResources, STATE_Caption %>" FieldName="STATE" ToolTip="<%$ Resources:GlobalResources, STATE_ToolTip %>" VisibleIndex="1">
                    <HeaderStyle Font-Names="Lucida Sans" />
                    <CellStyle Font-Names="Lucida Sans">
                    </CellStyle>
                    <Settings AutoFilterCondition="BeginsWith" ShowFilterRowMenu="True" />
                    <FilterCellStyle Font-Names="Lucida Sans">
                    </FilterCellStyle>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn Caption="<%$ Resources:GlobalResources, NAME_Caption %>" FieldName="NAME" ToolTip="<%$ Resources:GlobalResources, NAME_Caption %>" VisibleIndex="2">
                    <HeaderStyle Font-Names="Lucida Sans" />
                    <CellStyle Font-Names="Lucida Sans">
                    </CellStyle>
                    <Settings AutoFilterCondition="Contains" ShowFilterRowMenu="True" />
                    <FilterCellStyle Font-Names="Lucida Sans">
                    </FilterCellStyle>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn Caption="<%$ Resources:GlobalResources, AGENCY_Caption %>" FieldName="AGENCY" ToolTip="<%$ Resources:GlobalResources, AGENCY_Caption %>" VisibleIndex="3">
                    <HeaderStyle Font-Names="Lucida Sans" />
                    <CellStyle Font-Names="Lucida Sans">
                    </CellStyle>
                    <Settings AllowAutoFilter="False" />
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn Caption="<%$ Resources:GlobalResources, PHONE_NUMB_Caption %>" FieldName="PHONE_NUMB" ToolTip="<%$ Resources:GlobalResources, PHONE_NUMB_Caption %>" VisibleIndex="4">
                    <HeaderStyle Font-Names="Lucida Sans" />
                    <CellStyle Font-Names="Lucida Sans">
                    </CellStyle>
                    <Settings AutoFilterCondition="Contains" ShowFilterRowMenu="True" />
                    <FilterCellStyle Font-Names="Lucida Sans">
                    </FilterCellStyle>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn Caption="<%$ Resources:GlobalResources, FAX_Caption %>" FieldName="FAX" ToolTip="<%$ Resources:GlobalResources, FAX_Caption %>" VisibleIndex="4">
                    <HeaderStyle Font-Names="Lucida Sans" />
                    <CellStyle Font-Names="Lucida Sans">
                    </CellStyle>
                    <Settings AutoFilterCondition="Contains" ShowFilterRowMenu="True" />
                    <FilterCellStyle Font-Names="Lucida Sans">
                    </FilterCellStyle>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn Caption="<%$ Resources:GlobalResources, ADDRESS_Caption %>" FieldName="ADDRESS" ToolTip="<%$ Resources:GlobalResources, ADDRESS_Caption %>" VisibleIndex="5">
                    <HeaderStyle Font-Names="Lucida Sans" />
                    <CellStyle Font-Names="Lucida Sans">
                    </CellStyle>
                    <Settings AutoFilterCondition="Contains" ShowFilterRowMenu="True" />
                    <FilterCellStyle Font-Names="Lucida Sans">
                    </FilterCellStyle>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn Caption="<%$ Resources:GlobalResources, EMAIL_Caption %>" FieldName="NAME" ToolTip="<%$ Resources:GlobalResources, EMAIL_Caption %>" VisibleIndex="6">
                    <HeaderStyle Font-Names="Lucida Sans" />
                    <CellStyle Font-Names="Lucida Sans">
                    </CellStyle>
                    <DataItemTemplate>
                        <dx:ASPxHyperLink ID="lnkContact" runat="server" Text='<% #Eval("EMAIL") %>' NavigateUrl='<% #Eval("EMAIL","mailto:{0}") %>' ToolTip="<%$ Resources:GlobalResources, CONTACT_NAME_Instructions %>" Font-Names="Lucida Sans">
                        </dx:ASPxHyperLink>
                    </DataItemTemplate>
                    <Settings AutoFilterCondition="Contains" ShowFilterRowMenu="True" />
                    <FilterCellStyle Font-Names="Lucida Sans">
                    </FilterCellStyle>
                </dx:GridViewDataTextColumn>
                <dx:GridViewDataTextColumn Caption="<%$ Resources:GlobalResources, STATEURL_Caption %>" FieldName="STATEURL" ToolTip="<%$ Resources:GlobalResources, STATEURL_ToolTip %>" VisibleIndex="7">
                    <HeaderStyle Font-Names="Lucida Sans" />
                    <CellStyle Font-Names="Lucida Sans" Wrap="True">
                    </CellStyle>
                    <DataItemTemplate>
                        <dx:ASPxHyperLink ID="lnkStateUrl" runat="server" Text='<% #Eval("STATEURL") %>' NavigateUrl='<% #Eval("STATEURL") %>' Target="_blank" ToolTip="<%$ Resources:GlobalResources, STATE_Instructions %>" Font-Names="Lucida Sans">
                        </dx:ASPxHyperLink>
                    </DataItemTemplate>
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
        <asp:ObjectDataSource ID="odsContacts" runat="server" 
            SelectMethod="Contacts" TypeName="NLFA.OracleDataProvider">
        </asp:ObjectDataSource>
</asp:Content>

