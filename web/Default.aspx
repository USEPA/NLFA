<%@ page title="EPA - NLFA" language="VB" masterpagefile="~/Site.master" autoeventwireup="false" inherits="NLFA._Default, App_Web_default.aspx.cdcab7d2" enableEventValidation="false" viewStateEncryptionMode="Never" %>

<asp:Content ID="cStyles" ContentPlaceHolderID="cpStyles" Runat="Server">
    <link rel="stylesheet" type="text/css" href="jquery/css/black-tie/jquery-ui-1.8.16.custom.css" />
    <link rel="stylesheet" type="text/css" href="css/layout.css" />
</asp:Content>
<asp:Content ID="cScripts" ContentPlaceHolderID="cpScripts" Runat="Server">

    <script type="text/javascript" src="jquery/js/jquery-3.6.3.min.js"></script>
    <script type="text/javascript" src="https://code.jquery.com/ui/1.13.2/jquery-ui.min.js" integrity="sha256-lSjKY0/srUM9BE3dPm+c4fBo1dky2v27Gdjm2uoZaL0=" crossorigin="anonymous"></script>
    <script language="javascript" type="text/javascript">
        $(document).ready(function()
        {
            $("input:button").button();
        });
        function loadPage(pageName)
        {
            var newURL = window.location.protocol + "//" + window.location.host;
            pathArray = window.location.pathname.split('/');
            for (var i = 0; i < (pathArray.length - 1); i++)
            {
                newURL += pathArray[i];
                newURL += "/";
            }
            newURL += pageName;
            location.assign(newURL);
        }
    </script>
</asp:Content>
<asp:Content ID="cPageTitleBreadcrumb" ContentPlaceHolderID="cpPageTitleBreadcrumb" Runat="Server">
    NLFA Technical Information
</asp:Content>
<asp:Content ID="cPageTitle" ContentPlaceHolderID="cpPageTitle" Runat="Server">
    NLFA Technical Information
</asp:Content>
<asp:Content ID="cContent" ContentPlaceHolderID="cpContent" Runat="Server">

    <div id="nlfaMenu" class="ui-corner-all">
        <table id="mainTable">
            <tr>
                <td>
                    <input type="button" value="Technical Advisories Search" onclick="loadPage('Advisories.aspx');" />
                </td>
            </tr>
            <tr>
                <td>
                    <input type="button" value="Fish Tissue Search" onclick="loadPage('FishTissue.aspx');" />
                </td>
            </tr>
            <tr>
                <td class="left">
                    View NLFA General Information:
                </td>
            </tr>
            <tr>
                <td>
                    <input type="button" value="Advisories Where You Live" onclick="loadPage('General.aspx');" />
                </td>
            </tr>
        </table>
        <img alt="Fisherman at Lake Merced, California, By Mila Zinkova (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0) or GFDL (www.gnu.org/copyleft/fdl.html)], via Wikimedia Commons" title="Fisherman at Lake Merced, California, By Mila Zinkova (Own work) [CC-BY-SA-3.0 (www.creativecommons.org/licenses/by-sa/3.0) or GFDL (www.gnu.org/copyleft/fdl.html)], via Wikimedia Commons" src="images/Fisherman_at_Lake_Merced.jpg" class="ui-corner-all" />
        <div style="clear:both;height:0px;">&nbsp;</div>
    </div>
</asp:Content>

