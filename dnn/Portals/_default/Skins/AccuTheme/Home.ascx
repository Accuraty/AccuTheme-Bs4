<div id="skin-home" class="dnn-skin-wrapper skin-home">
<!--#include file="includes/_preheader.ascx"-->
<!--#include file="includes/_header.ascx"-->

<%-- see src/scripts/README.md, Individual files - to implement Home (page) specific JS --%>
<%-- <dnn:DnnJsInclude
  FilePath="dist/Home.bundle.js"
  PathNameAlias="SkinPath"
  ForceProvider="DnnFormBottomProvider"
  Priority="106"
  runat="server"
/> --%>

<main class="main" role="main" id="home">

  <%-- Don't render any HTML unless the pane has content. --%>
  <% if (ContentPane.Visible == true) { %>
    <section class="section">
      <div class="container">
        <div class="row">
          <div
            id="ContentPane"
            class="col-12"
            visible="false"
            runat="server"
          ></div>
        </div>
      </div>
    </section>
  <% } %>
</main>

<!--#include file="includes/_footer.ascx"-->
</div>
