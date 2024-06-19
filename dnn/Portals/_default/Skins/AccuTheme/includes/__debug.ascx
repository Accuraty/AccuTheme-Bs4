<%-- 
  /** << this triggers Better Comments extension

  >>> UNFINISHED version copied to PDEG, CPHP, CCFP, BEACN, BBIOP, ASL2022, PDPRAPI, CUAM2020, ARPAS2023, RRMA2024
  BUG showDebug is not working as expected due to "scope-confusion", see logDebug below (~line 196)
  BUG with details/on or all, the debug output shows but not the details when NOT at an allowed IP
  TODO on older projects with old DNN versions, we may need to add add DLLs for System.Text.Json? 
       ? >>> NO, undoing that, we'll use Newtonsoft.Json since its already in DNN v8-9.12, v8.00.04 has v7.0.1
  TODO convert the Key DLLs to a List<string> in DebugSettings and loop through them to GetVersion()s
  TODO synthesise the JsonFileLocations? see notes/ideas in LoadAllowedIps() after if (loc.StartsWith("http")) {
  TODO (started) show DNN security-related settings; PB ... More Security Settings, Show Critical Errors, Debug Mode
  TODO this could be more helpful if there was an ENV or global setting showing if the site is in production (live) or not; e.g. certain settings could become warnings
  DONE with Session and Persistence, show whether or not DNN has Enable Remember on or off (Security/More)
  ? "DebugSettings" is a bad name, maybe "DebugInfo" or "DebugDetails" or "DebugOutput" 

  future/other things:
  ? clean up and remove all the old stuff and anything unused?
  ? add (an option?) to show things grouped by headings in an accordion (use <details>?) and set which ones are open by default
  ? other admins/agencies might have different needs (than Accuraty), so maybe make it more configurable
  ? Re-write again as an installable extension? how to we hook to the end of the page/footer?
  
  * RE-WRITE - slow experimental/learning re-write of __debug.ascx started 20230709-0729 JRF
  ! Primary goal is to be able to drop in and use in any project with no (minimal?) changes 
  Self contained, single file, no dependencies (on AccuKit, AccuTheme, etc. Well, except Bootstrap (for now))  
  Functions used from other places: isIpSpecial(), isUrlSpecial(), GetVersion(), GetIpAddress() << at bottom of this file
  Functions new to this version: GetAuthTimeout(), GetPersistentTimeout() (both from web.config)
  Added DebugSettings static class to make it easier to update settings to match the project/site and environment
  Added loading of AllowedIps from remote or local JSON file with caching, failover, and final fallback (AllowedIpsListFallback)
  Tested and adjusted the flow of loading the JSON from locations and caching, then failover
  Add debugOutput and lots of comments that make the flow easier to follow
  Added indicator to show when login is regular or persistent 

  Also, for compatibility with older DNN sites (without CodeDom updated):
  - removed Interpolations ($"{var}") 
  - moved TryParse _out_ type to separate line ( can't do double.TryParse(mins, out double result) )
  -------------------------------------------------------------------------------^^
  * there is probably (compatibility-wise) more that we haven't encountered or thought of (yet)

  **/
--%>
<script runat="server">
  // STEP 0: add file to theme/includes/, then add to footer.ascx and test (missing DLLs?)

  // in production (live), set to false 
  const bool isDebug = false; // disable debug output // stuff only useful while developing
  const string debugVersion = "2023.07.29-prerelease";

  // STEP 1: UPDATE THESE VALUES TO MATCH YOUR SITE AND ENVIRONMENT (then delete this comment)
  public partial class DebugSettings // ? rename to DebugDetails or ??
  {
    public static string BootstrapVersion = "4.6.2"; // set this to match actual (usually via package.json)
    // final fallback list if remote/local locations fail
    public static List<string> AllowedIpsListFallback = new List<string> { 
      "127.0.0.1", 
      "140.141.191.145" 
    }; 
    // details about where to try and load the JSON file from 
    public static string JsonDefaultFilename = "accu-settings.json"; // if not specified
    public static string JsonElementNameAllowedIps = "AllowedIps"; // the name of the node containing the array of IPs
    public static string JsonLocalFailoverPath = "/Portals/_default/"; // relative to root
    // we will try these in order until one works (or all fail):
    public static List<string> JsonFileLocations = new List<string>() { 
      // if the filename is not specified, JsonDefaultFilename will be appended
      "https://accuraty.com/Portals/_default/" + JsonDefaultFilename, // primary
      "HostPath", // special; will load via file system (path + default filename)
      "https://www.accu4.com/Portals/_default",
    }; 
    // we use DNN's cache to store the list of allowed IPs
    public static int CacheTimeout = 60; // minutes
    public static string CacheKeyAllowedWanIps = "FooterDebug-AllowedWanIps";
    // setup your optional special URL parameter add on to trigger debug output (e.g. ?debug=on or /debug/on)
    public static string SpecialUrlOutputName = "details"; // default
    public static string SpecialUrlOutputValue = "on"; // default; shows only details
    public static string SpecialUrlDebugValue = "debug"; // shows only debug info (logged)
    public static string SpecialUrlAllValue = "all"; // shows both details and debug info
  }
</script>

<% 
  bool showDetails = isIpSpecial() 
    || isUrlSpecial(DebugSettings.SpecialUrlOutputName, DebugSettings.SpecialUrlOutputValue)
    || isUrlSpecial(DebugSettings.SpecialUrlOutputName, DebugSettings.SpecialUrlAllValue);
  bool showDebug = isDebug
    || isUrlSpecial(DebugSettings.SpecialUrlOutputName, DebugSettings.SpecialUrlDebugValue)
    || isUrlSpecial(DebugSettings.SpecialUrlOutputName, DebugSettings.SpecialUrlAllValue);

  if ( showDetails ) { 
%>
  <div class="alert alert-warning m-0 text-monospace d-none d-lg-block d-print-none" role="alert">
    <%-- DNN / HOST --%>
    <div class="mb-2">
      <p>
        DNN <%=DotNetNuke.Application.DotNetNukeContext.Current.Application.Version.ToString(3) %> / <%=System.Environment.Version.ToString() %> / Host=<%=System.Net.Dns.GetHostName() %>, 
        DebugMode: <%=DotNetNuke.Entities.Host.Host.DebugMode.ToString() %>, 
        ShowCriticalErrors: <%=DotNetNuke.Entities.Host.Host.ShowCriticalErrors.ToString() %>
      </p>
    </div>

    <%-- THEME --%>
    <div class="mb-2">
      <p>Theme: 
        Skin: <strong><%=PortalSettings.DefaultPortalSkin.Split('/')[1].ToUpper() %></strong>, 
        Layout / Container: <span title="<%=PortalSettings.DefaultPortalSkin %>"><%=System.IO.Path.GetFileNameWithoutExtension(PortalSettings.DefaultPortalSkin) %></span>
          / <span title="<%=PortalSettings.ActiveTab.ContainerSrc %>"><%=System.IO.Path.GetFileNameWithoutExtension(PortalSettings.ActiveTab.ContainerSrc) %></span>, 
        Bootstrap=<span title="no plans to upgrade Bootstrap to v5 - 202108 JRF">v<%=DebugSettings.BootstrapVersion %></span>
        <a href="https://github.com/Accuraty/AccuTheme-2021/tree/main/src/styles#bootstrap" target="_blank" rel="noopener noreferrer" class="ml-1">(read me)</a>
      </p>
    </div>

    <%-- PAGE --%>
    <div class="mb-2">
      <p class="mb-1">Page: TabID=<%=PortalSettings.ActiveTab.TabID %>, 
        Name=<%=PortalSettings.ActiveTab.TabName %>, 
        Title=<%=PortalSettings.ActiveTab.Title %>, 
        Layout / Container: <span title="<%=PortalSettings.ActiveTab.SkinSrc %>"><%=System.IO.Path.GetFileNameWithoutExtension(PortalSettings.ActiveTab.SkinSrc) %></span>
          / <span title="<%=PortalSettings.ActiveTab.ContainerSrc %>"><%=System.IO.Path.GetFileNameWithoutExtension(PortalSettings.ActiveTab.ContainerSrc) %></span>
      </p>
      <div class="px-3">
        <div class="mb-0">Status: 
          <span title="Display in Menus, Navigation">IsVisible=<%=PortalSettings.ActiveTab.IsVisible %>, </span>  
          <span>Published=<%=PortalSettings.ActiveTab.HasBeenPublished %> </span>
        </div>
        <p class="mb-0 text-break">
          Nav: Level=<%=PortalSettings.ActiveTab.Level %>, 
          Path=<%=PortalSettings.ActiveTab.TabPath %>, 
          <span title="Disabled in Nav/Menus (e.g. not a link, just a parent)">DisableLink=<%=PortalSettings.ActiveTab.DisableLink %> </span>
        </p>
        <p class="mb-0" title="What? You didn't know that tabid and language are always there?">QueryString pairs: <%=Request.QueryString.ToString().Replace("&",", ") %></p>
      </div>
    </div>

    <%-- DLLs --%>
    <div class="mb-2">
      <p title="These versions are coming from the DLLs in /bin (using Reflection)">Key DLL Versions: 
        DNN: <%=GetVersion("DotNetNuke") %>, 
        MS DI: <%=GetVersion("Microsoft.Extensions.DependencyInjection") %>, 
        NewtonsoftJson: <%=GetVersion("Newtonsoft.Json") %>, 
        CodeDom: <%=GetVersion("Microsoft.CodeDom.Providers.DotNetCompilerPlatform") %>,
        <br>
        2sxc: <%=GetVersion("ToSic.Sxc") %>, 
        DNNBackup: <%=GetVersion("Evotiva.DNN.Modules.DNNBackup") %>,
        AccuLadder: <%=GetVersion("Accuraty.Libraries.AccuLadder") %>,
        Booyada: <%=GetVersion("Booyada") %> <!-- testing not found -->
      </p>
    </div>
  
    <%-- Login URL 
    <div class="mb-2">
      <p>Login URL: <%=System.Configuration.ConfigurationManager.AppSettings["loginUrl"] %></p>
    </div>
    <hr />
    --%>
    <%-- SMALL PRINT --%>
    <div class="small text-dark">
      <p class="mb-0"
        title="Current user details..."
      >Current User: <%=currUserInfo().UserID %>, <%=currUserInfo().Username %>, <%=currUserInfo().DisplayName %>, <%=currUserInfo().Email %>
      </p>
      <p class="mb-0"
        title="Current user's role details..."
      > +-- permissions are <%=currUserRoles() %>
      </p>
      <p class="mb-0"
        title="This is how long your session will last before you are logged out you are not actively using the site and do NOT check Remember."
      >Authentication Timeout: <%=GetAuthTimeout() %>
      </p>
      <p class="mb-0"
        title="This is how long your session will last before you are logged out you are not actively using the site AND check Remember."
      >PersistentCookieTimeout: <%=GetPersistentTimeout() %>, RememberCheckbox: <%=DotNetNuke.Entities.Host.Host.RememberCheckbox.ToString() %> 
      </p>
      <p class="mb-0">
        Using <code><%=System.Configuration.ConfigurationManager.AppSettings["UpdateServiceUrl"] %></code> for updates. 
        Deployed on <%=System.Configuration.ConfigurationManager.AppSettings["InstallationDate"] %> 
        at Dnn version <%=System.Configuration.ConfigurationManager.AppSettings["InstallVersion"] %>,
      </p>
      <p class="mb-0">WAN IP: <%=GetIpAddress() %>, page output <%=DateTime.Now.ToString("F") %></p>
    </div>

    <p class="small mt-2 mb-0"
      title="__debug.ascx v<%=debugVersion %>, isIpSpecial()=<%=showDetails %>, isUrlSpecial()=<%=isUrlSpecial() %>"
    >
      <span class="font-weight-bold">Debug info being output from <code>includes/_footer.ascx</code> in Skin.</span>
      This is only visible from configured WAN IP addresses or URL name/value pair. Hovering on some elements reveals more info.
    </p>

  </div>
<% } %>

<% if ( showDebug ) { %>
<div style="margin:0;padding:1rem;background-color:lightgray;">
<p style="font-size:larger;font-weight:bold;">DEBUGGING OUTPUT (showDebug is true, isDebug is <%=isDebug %>), WAN IP: <%=GetIpAddress() %></p>
<pre>
debugOutput:
<%=debugOutput.ToString().Trim() %>

HttpContext
.Current.Request.IsLocal:         <%=HttpContext.Current.Request.IsLocal %>
.UserHostAddress:                 <%=HttpContext.Current.Request.UserHostAddress %>
.ServerVariables["LOCAL_ADDR"]:   <%=HttpContext.Current.Request.ServerVariables["LOCAL_ADDR"] %>
.ServerVariables["REMOTE_ADDR"]:  <%=HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"] %>
.Headers["CF-Connecting-IP"]:     <%=HttpContext.Current.Request.Headers["CF-Connecting-IP"] %>
.Headers["X-Forwarded-For"]:      <%=HttpContext.Current.Request.Headers["X-Forwarded-For"] %>

GetIpAddress():                   <%=GetIpAddress() %>
</pre>
</div>
<% } %>

<script runat="server">
  // set whether to logDebug or not
  bool logDebug = isDebug;
<%-- 
  BUG fix this, throws error due to scope of showDebug, etc.
  logDebug = logDebug 
    || isUrlSpecial(DebugSettings.SpecialUrlOutputName, DebugSettings.SpecialUrlDebugValue)
    || isUrlSpecial(DebugSettings.SpecialUrlOutputName, DebugSettings.SpecialUrlAllValue);
--%>  
  // Get the version of an installed DLL in /bin
  // expecting "ToSic.Razor" and we assume /bin and add .dll
  string GetVersion(string pathFile) {
    // should the bin/dll (path/ext) pattern be a setting?
    string addPathExt = "bin/{0}.dll";
    string target = HttpContext.Current.Server.MapPath(string.Format(addPathExt, pathFile));
    if(System.IO.File.Exists(target)) {
      return System.Reflection.Assembly.LoadFrom(target).GetName().Version.ToString();
    }
    else {
      return "Not found (/" + string.Format(addPathExt, pathFile) + ")";
    }
  }  
  // does the URL contain the expected secret?
  // do {something} only if URL has "/debug/on" or "&debug=on" added
  bool isUrlSpecial(string urlParamName = "debug", string urlParamValue = "on") {
    return urlQSParam(urlParamName, "") == urlParamValue;
  }
  // safely fetch our URL Param
  string urlQSParam(string urlParamName = "debug", string returnFalse = "") {
    if(!string.IsNullOrEmpty(Request.QueryString[urlParamName])) {
      return Request.QueryString[urlParamName];
    } else {
      return returnFalse;
    }
  }
  // Get IP address of the visitor
  string GetIpAddress() {
    string stringIpAddress;
    // is this still correct in 2023? is there a better way?
    stringIpAddress = Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
    if (stringIpAddress == null) {
      stringIpAddress = Request.ServerVariables["REMOTE_ADDR"];
    }
    return stringIpAddress;
  }
  // From web.config, get the normal login timeout (system.web/authentication) for the session
  string GetAuthTimeout() {
    System.Configuration.Configuration config = System.Web.Configuration.WebConfigurationManager.OpenWebConfiguration("~");
    System.Web.Configuration.AuthenticationSection authSection = (System.Web.Configuration.AuthenticationSection)config.GetSection("system.web/authentication");
    TimeSpan timeSpan = authSection.Forms.Timeout;
    string auth = (HttpContext.Current.User.Identity.IsAuthenticated && !IsPersistent()) ? "<<" : "";
    return string.Format("{0} (mins), which is {1} hour(s) and {2} minute(s) {3}", timeSpan.TotalMinutes, timeSpan.TotalHours, timeSpan.Minutes, auth);
  }
  // From web.config, get the persistent cookie timeout (an appSetting)
  string GetPersistentTimeout() {
    string mins = System.Configuration.ConfigurationManager.AppSettings["PersistentCookieTimeout"];
    double result; // don't move this to "out double result" (below) because we need to be compatible with C# < 7.x
    if (double.TryParse(mins, out result))
    {
      TimeSpan timeSpan = TimeSpan.FromMinutes(result);
      string auth = (HttpContext.Current.User.Identity.IsAuthenticated && IsPersistent()) ? "<<" : "";
      return string.Format("{0} (mins), which is {1} day(s) and {2} hour(s) {3}", mins, timeSpan.Days, timeSpan.Hours, auth);
    }
    else
    {
      // Handle the case where mins is not a valid number...
      return "Invalid value in AppSettings[\"PersistentCookieTimeout\"]"; 
    }    
  }
  // is the current user authenticated with a Persistence? (i.e. a persistent cookie)
  bool IsPersistent() {
    if (Request.Cookies[FormsAuthentication.FormsCookieName] != null) {
      FormsAuthenticationTicket ticket = FormsAuthentication
        .Decrypt(Request.Cookies[FormsAuthentication.FormsCookieName].Value);
      return ticket.IsPersistent;
    } else {
      return false;
    }
  }
  //
  // by IP, is the remote IP address a known Accuraty WAN IP?
  bool isIpSpecial() {
    if (logDebug) debugOutput.AppendLine("isIpSpecial() begins...");
    // BUG always returns true, WTF? Added Debug output for HttpContent for IPs (unfinished)
    if (HttpContext.Current.Request.IsLocal) {
      if (logDebug) debugOutput.AppendLine("isIpSpecial() Request.IsLocal is true");
      return true;
    }
    List<string> list = GetAllowedIps();
    // a lot just happened, if it was successful, we have a list of IPs, but if not...
    if (list.Count == 0) { // final fallback
      list = DebugSettings.AllowedIpsListFallback;
      // note that we do NOT cache the fallback list (caching happens only in LoadAllowedIps())
      // IDEA though there is some logic to caching the fallback with a reduced cache timeout (e.g. 2 mins?)
      if (logDebug) debugOutput.AppendLine("isIpSpecial() - list.Count == 0, so using DebugSettings.AllowedIpsListFallback <<< THIS IS BAD!");
      // TODO Send an Email to the Admins that the list of allowed IPs needs fixing?
    }
    if (logDebug) debugOutput.AppendLine("isIpSpecial() completed");
    if (logDebug) debugOutput.AppendLine("");
    return list.Contains(GetIpAddress());
  }

  // Debugging output
  StringBuilder debugOutput = new StringBuilder();
  
  // Get/Cache the JSON file that contains the list of Accuraty WAN IP addresses
  // The list of failoverUrls is defined at the top of this file

  string rawJson = string.Empty;

  // cache key and timeout defined in DebugSettings above
  List<string> GetAllowedIps() {
    if (logDebug) debugOutput.AppendLine("GetAllowedIps() begins...");
    // First. we try to load the list of AllowedIPs from DNN's cache
    List<string> allowedIps = DotNetNuke.Common.Utilities.DataCache.GetCache<List<string>>(DebugSettings.CacheKeyAllowedWanIps);
    
    if (allowedIps == null) {
      // its not in the cache, so we need to load it
      if (logDebug) debugOutput.AppendLine("GetAllowedIps() Not in cache, so we need to load it; ");
      allowedIps = LoadAllowedIps(); // this also caches it
    }
    else {
      if (allowedIps.Count > 0) {
        if (logDebug) debugOutput.Append("GetAllowedIps() Found in cache; ");
      }
      else {
        // this shouldn't happen because we don't SetCache unless the IP count > 0, but... 
        if (logDebug) debugOutput.AppendLine("GetAllowedIps() Found in cache, but list is empty; ");
        allowedIps = LoadAllowedIps();
      }
    }
    if (logDebug) {
      debugOutput.AppendLine("GetAllowedIps() completed with Count=" + allowedIps.Count + ", List: " + string.Join(", ", allowedIps));
    }
    return allowedIps;
  }

  // Load the list of Accuraty WAN IP addresses from the list of Failover URLs
  List<string> LoadAllowedIps() {
    if (logDebug) debugOutput.AppendLine("LoadAllowedIps() begins...");
    List<string> allowedIps = new List<string>();
    // we need a list of places in priority order to load the JSON settings file from; 
    // >> List<string> JsonFileLocations is defined at the top of this file

    if (logDebug) debugOutput.AppendLine("LoadAllowedIps() foreach loop begins... DebugSettings.JsonFileLocations.Count:" + DebugSettings.JsonFileLocations.Count);

    // it contains both URLs and local file paths
    int index = 0;
    foreach (string location in DebugSettings.JsonFileLocations) {
      index = DebugSettings.JsonFileLocations.IndexOf(location);
      if (logDebug) debugOutput.Append("LoadAllowedIps() " + index.ToString() + " location: " + location);
      // handle specials (initially only "HostPath")
      string loc = location;
      switch (location) {
        case "HostPath":
          // convert to DNN HostPath + default filename
          loc = DotNetNuke.Common.Globals.HostMapPath + DebugSettings.JsonDefaultFilename;
          if (logDebug) debugOutput.Append(" >> converted: " + loc);
          break;
        default:
          break;
      }

      // URL or Local path/file?
      if (loc.StartsWith("http")) {
        // IDEA should we try as-is first, then start mucking around?
        // is the filename included? No, so add JsonDefaultFilename
        // does the filename have an extension? No, so add "/" + JsonDefaultFilename
        // do we care if it is not .json? (could come from an API url in the future?)
        /// var afile = System.IO.Path.GetFileName(loc);
        /// if (logDebug) debugOutput.Append("[ filename: " + afile + ", " + (afile == string.Empty).ToString() + " ]");
        bool retry = false;
        try {
          // try to get the JSON from the URL
          using (var client = new System.Net.WebClient()) {
            rawJson = client.DownloadString(loc);
          }
        } catch (Exception ex) {
          // if we got an error, log it and try the next URL
          if (logDebug) debugOutput.AppendLine(string.Format(" << URL FAILED: {0}", ex.Message));
          continue;
        }
      } else {
        // Local path/file
        try {
          // try to get the JSON from the local file
          rawJson = System.IO.File.ReadAllText(loc);
        } catch (Exception ex) {
          // if we got an error, log it and try the next URL
          if (logDebug) debugOutput.AppendLine(string.Format(" << FILE FAILED: {0}", ex.Message));
          continue;
        }
      }
      // if we got Valid JSON and we parsed at least 1 allowed IP, break out of the foreach loop
      if (!string.IsNullOrEmpty(rawJson)) {
        if (logDebug) debugOutput.Append(" << returned something; ");
        // we got something, but is it valid JSON?
        if (IsValidJson(rawJson)) {
          if (logDebug) debugOutput.AppendLine("Valid JSON, now we parse it...");
          allowedIps = ParseAllowedIps(rawJson);
          if (allowedIps.Count > 0) {
            break;
          }
          else
          {
            if (logDebug) debugOutput.AppendLine(" ^^ JSON IS VALID, but the list is empty");
            continue;
          }
        } else {
          // not valid JSON, so try the next URL
          if (logDebug) debugOutput.AppendLine(" ^^ JSON IS NOT VALID");
          continue;
        }
      }
    }
    if (logDebug) debugOutput.AppendLine("LoadAllowedIps() foreach loop completed");
    // if we got here, we have a list of allowed IPs, or an empty list
    if (allowedIps.Count > 0)
    {
      // DNN cache the list
      if (logDebug) debugOutput.AppendLine("LoadAllowedIps() DNN SetCache-ing the list of allowed IPs");
      DotNetNuke.Common.Utilities.DataCache.SetCache(DebugSettings.CacheKeyAllowedWanIps, allowedIps, TimeSpan.FromMinutes(DebugSettings.CacheTimeout));
      // if allowedIps is > 0 and this is the first/primary location, we 
      // just re-write the secondary location (local default file) every time?
      if (index == 0) {
        // write the JSON to the local file
        // TODO only write if it is different than what is already there
        // TODO only write if the versions are different (rawJson.Version exists)
        // TODO put in a Try/Catch just in case?
        if (logDebug) debugOutput.AppendLine("LoadAllowedIps() writing the rawJson to the local file, HostPath/" + DebugSettings.JsonDefaultFilename);
        System.IO.File.WriteAllText(DotNetNuke.Common.Globals.HostMapPath + DebugSettings.JsonDefaultFilename, rawJson);
      }
    }
    if (logDebug) debugOutput.AppendLine("LoadAllowedIps() completed");
    return allowedIps;
  }

  // note that we have already done IsValidJson() on the rawJson before we got here (in LoadAllowedIps())
  List<string> ParseAllowedIps(string rawJson) {
    if (logDebug) debugOutput.AppendLine("ParseAllowedIps() begins...");
    List<string> allowedIps = new List<string>();

    using (System.Text.Json.JsonDocument document = System.Text.Json.JsonDocument.Parse(rawJson))
    {
      System.Text.Json.JsonElement root = document.RootElement;
      System.Text.Json.JsonElement allowedIpsElement;

      if (logDebug) debugOutput.AppendLine("ParseAllowedIps() expecting node named: \"" + DebugSettings.JsonElementNameAllowedIps + "\"");
      if (root.TryGetProperty(DebugSettings.JsonElementNameAllowedIps, out allowedIpsElement))
      {
        if (logDebug)
        {
          debugOutput.AppendLine("ParseAllowedIps() allowedIpsElement: found, contains:");
          debugOutput.AppendLine(Regex.Replace(allowedIpsElement.ToString(), "\\s", ""));
        }
      }
      else
      {
        if (logDebug) debugOutput.AppendLine("ParseAllowedIps() allowedIpsElement: NOT found");
      }

      if (allowedIpsElement.ValueKind == System.Text.Json.JsonValueKind.Undefined)
      {
        if (logDebug) debugOutput.AppendLine("ParseAllowedIps() allowedIpsElement: returned undefined");
      }
      else
      {
        if (allowedIpsElement.ValueKind == System.Text.Json.JsonValueKind.Array)
        {
          foreach (System.Text.Json.JsonElement ipElement in allowedIpsElement.EnumerateArray())
          {
            allowedIps.Add(ipElement.GetProperty("ip").GetString());
          }
        }
        else
        {
          if (logDebug) debugOutput.AppendLine("ParseAllowedIps() allowedIpsElement: NOT an array");
        }
      }
    }

    if (logDebug) debugOutput.AppendLine("ParseAllowedIps() completed, allowedIps.Count: " + allowedIps.Count.ToString() + "");
    return allowedIps;
  }

  // does the given string contain valid JSON (using System.Text.Json)?
  bool IsValidJson(string rawJson) {
    rawJson = rawJson.Trim();
    bool isValid = false;
    if ((rawJson.StartsWith("{") && rawJson.EndsWith("}")) // for object
        || (rawJson.StartsWith("[") && rawJson.EndsWith("]"))) // for array
    {
      try {
        using (var document = System.Text.Json.JsonDocument.Parse(rawJson)) {
          isValid = true;
        }
      } 
      catch (System.Text.Json.JsonException jex) {
        if (logDebug) debugOutput.AppendLine(string.Format("IsValidJson() FAILED: {0}", jex.Message));
      }
      catch (Exception ex) {
        if (logDebug) debugOutput.AppendLine(string.Format("IsValidJson() FAILED: {0}", ex.Message));
      }
    }
    return isValid;
  }

  private static UserInfo _userInfo = null;
  public UserInfo currUserInfo()
  {
    if (_userInfo == null
      || _userInfo != DotNetNuke.Entities.Users.UserController.Instance.GetCurrentUserInfo()
    )
    {
      _userInfo = DotNetNuke.Entities.Users.UserController.Instance.GetCurrentUserInfo();
    }
    return _userInfo;
  }
  public string currUserRoles()
  {
    StringBuilder sb = new StringBuilder();
    if (currUserInfo().IsSuperUser)
    {
      sb.Append("[SuperUser] and ");
    }
    sb.Append("Roles: ");
    foreach (string role in currUserInfo().Roles)
    {
      if (role != "Registered Users" && role != "Subscribers")
      {
        sb.Append(role + ", ");
      }
    }
    return sb.ToString().TrimEnd(new char[] { ',', ' ' });
  }

  // IDEA we are NOT using this... BUT should we convert and do it this way with task/await?
  <%-- 
  public async System.Threading.Tasks.Task<List<string>> GetAllowedIpsAsync(string url)
  {
    using (System.Net.Http.HttpClient client = new System.Net.Http.HttpClient())
    {
      System.Net.Http.HttpResponseMessage response = await client.GetAsync(url);
      response.EnsureSuccessStatusCode();
      string jsonString = await response.Content.ReadAsStringAsync();

      using (System.Text.Json.JsonDocument document = System.Text.Json.JsonDocument.Parse(jsonString))
      {
        System.Text.Json.JsonElement root = document.RootElement;
        System.Text.Json.JsonElement allowedIpsElement = root.GetProperty("allowedIps");

        List<string> allowedIps = new List<string>();
        foreach (System.Text.Json.JsonElement ipElement in allowedIpsElement.EnumerateArray())
        {
          allowedIps.Add(ipElement.GetString());
        }

        return allowedIps;
      }
    }
  }
   --%>
</script>
