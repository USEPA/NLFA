<%@ page title="<%$ Resources:GlobalResources, SiteErrorPageTitle %>" language="VB" masterpagefile="~/Site.master" autoeventwireup="false" inherits="NLFA._Error, App_Web_error.aspx.cdcab7d2" enableEventValidation="false" viewStateEncryptionMode="Never" %>

<asp:Content ID="cStyles" ContentPlaceHolderID="cpStyles" Runat="Server">
</asp:Content>
<asp:Content ID="cScripts" ContentPlaceHolderID="cpScripts" Runat="Server">
</asp:Content>
<asp:Content ID="cParentPageLink" ContentPlaceHolderID="cpParentPageLink" Runat="Server">
</asp:Content>
<asp:Content ID="cPageTitleBreadcrumb" ContentPlaceHolderID="cpPageTitleBreadcrumb" Runat="Server">
    <asp:Label ID="lblPageTitleBreadcrumb" runat="server" Text="<%$ Resources:GlobalResources, SiteErrorTitle %>"></asp:Label>
</asp:Content>
<asp:Content ID="cPageTitle" ContentPlaceHolderID="cpPageTitle" Runat="Server">
    <asp:Label ID="lblPageTitle" runat="server" Text="<%$ Resources:GlobalResources, SiteErrorTitle %>"></asp:Label>
</asp:Content>
<asp:Content ID="cContent" ContentPlaceHolderID="cpContent" Runat="Server">
    <p><asp:Label ID="lblPageDescription" runat="server" Text="<%$ Resources:GlobalResources, SiteErrorDescription1 %>"></asp:Label></p>
    <ul>
        <li>
            <asp:HyperLink ID="lnkHome" runat="server" Text="<%$ Resources:GlobalResources, SiteErrorDescription2 %>" ToolTip="<%$ Resources:GlobalResources, SiteErrorDescription2 %>" Target="_self" NavigateUrl="<%$ Resources:GlobalResources, SiteErrorReturnUrl %>"></asp:HyperLink>
        </li>
    </ul>
</asp:Content>
