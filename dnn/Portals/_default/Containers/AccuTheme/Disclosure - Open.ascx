<%@ Control AutoEventWireup="false" Explicit="True" Inherits="DotNetNuke.UI.Containers.Container" %>
<%@ Register TagPrefix="dnn" TagName="TITLE" Src="~/Admin/Containers/Title.ascx" %>
<%@ Import Namespace="DotNetNuke.Web.Client.ClientResourceManagement" %><%--  --%>

<details open class="dnn-container container-disclosure">
  <summary><dnn:TITLE runat="server" id="dnnTITLE" CssClass="h3" /></summary>
  <div id="ContentPane" runat="server"></div>
</details>
