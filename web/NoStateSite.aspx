<%@ page title="<%$ Resources:GlobalResources, GeneralPageTitle %>" language="VB" masterpagefile="~/Site.master" autoeventwireup="false" inherits="NLFA.NoStateSite, App_Web_nostatesite.aspx.cdcab7d2" enableEventValidation="false" viewStateEncryptionMode="Never" %>

<asp:Content ID="cStyles" ContentPlaceHolderID="cpStyles" Runat="Server">
</asp:Content>
<asp:Content ID="cScripts" ContentPlaceHolderID="cpScripts" Runat="Server">
</asp:Content>
<asp:Content ID="cPageTitleBreadcrumb" ContentPlaceHolderID="cpPageTitleBreadcrumb" Runat="Server">
    <asp:Label ID="lblPageTitleBreadcrumb" runat="server" Text="<%$ Resources:GlobalResources, GeneralTitle %>"></asp:Label>
</asp:Content>
<asp:Content ID="cPageTitle" ContentPlaceHolderID="cpPageTitle" Runat="Server">
    <asp:Label ID="lblPageTitle" runat="server" Text="<%$ Resources:GlobalResources, GeneralTitle %>"></asp:Label>
</asp:Content>
<asp:Content ID="cContent" ContentPlaceHolderID="cpContent" Runat="Server">
    <p style="height:450px">
        <asp:Label ID="lblMissingWebsite" runat="server"></asp:Label>
    </p>
</asp:Content>

