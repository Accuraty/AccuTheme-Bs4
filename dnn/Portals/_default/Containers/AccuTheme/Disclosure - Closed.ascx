<%@ Control AutoEventWireup="false" Explicit="True" Inherits="DotNetNuke.UI.Containers.Container" %>
<%@ Register TagPrefix="dnn" TagName="TITLE" Src="~/Admin/Containers/Title.ascx" %>
<%@ Register TagPrefix="dnn" Namespace="DotNetNuke.Web.Client.ClientResourceManagement" Assembly="DotNetNuke.Web.Client" %>

<%-- IMPORTANT NOTE: the CSS for Containers is an AccuTheme Bootstrap component found here: /src/styles/theme/components/_dnn-containers.scss --%>

<details class="dnn-container container-disclosure">
  <summary><dnn:TITLE runat="server" id="dnnTITLE" CssClass="h3" /></summary>
  <div id="ContentPane" runat="server"></div>
</details>
