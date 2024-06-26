<%--
  This is abstracted to its own include so it can be reused. By default, it
  is included in `_header.ascx` and `_footer.ascx`. We prefer to use SVG files
  for logos not only because vectors are better, but also because that allows
  us to target them via CSS to change attributes like size and color.

--%>

<%-- 0. DEFAULT - just include the AccuTheme SVG
<!--#include file="../dist/media/svg/AccuTheme-logo.svg"-->
 --%>

<%-- 1. RECOMMENDED - use DNN settings and inject
Generally we should do it the Dnn-way first, 
note that around Dnn 9.4 they added the InjectSvg option 
MPORTANT: using this version requires changing _header.ascx so we 
are not already wrapped in an A tag (since Dnn emits one)
Note: since this is re-used in _footer.ascx, no ID (it would cause an error)
Note: old LinkCssClass removed 20240618 JRF - LinkCssClass="navbar-brand dnnLogo w-25 mr-5" 
--%>
  <dnn:LOGO 
    CssClass="img-fluid" 
    LinkCssClass="" 
    InjectSvg="true" 
    runat="server"  
  />

<%-- 2. ALT - hard-coded IMG tag, still using Dnn Settings
<a
  class="navbar-brand position-relative d-flex"
  href="/"
  aria-label="_xx___CLIENT_NAME___xx_"
>
  <img
    class="img-fluid"
    src="<%=PortalSettings.HomeDirectory %><%=PortalSettings.LogoFile %>"
    alt="_xx___CLIENT_NAME___xx_"
  /> 
</a>
--%>
