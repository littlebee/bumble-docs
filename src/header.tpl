<header>
  <div>
    <!-- relativeRoot is the relative path to root for the file being generated  -->
    <img src="<%= relativeRoot %>/<%= configFile.logo %>" href="/docs">
    <em><%= npmPackage.description %></em>
  </div>
  <div class='main-menu no-print'>
    <a class='main-menu-item' href="<%=relativeRoot%>/docs">Introduction and Getting Started </a>
    <a class='main-menu-item' href="<%=relativeRoot%>/docs/examples">Live Demo &amp; Examples</a>
    <a class='main-menu-item' href="<%=relativeRoot%>/docs/api">API Docs</a>
  </div>
  <a class='github-link no-print' href="<%= npmPackage.repository.url %>" target="blank">
    View on Github
  </a>

</header>

<script>
  $($($('.main-menu-item')[<%= selectedItem %>]).addClass('selected'))
</script>