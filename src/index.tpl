<!DOCTYPE html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta http-equiv="X-UA-Compatible" content="chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    
    <link rel="stylesheet" type="text/css" href="<%= relativeRoot %>/docs/css/react-datum.css">
    <link rel="stylesheet" type="text/css" href="<%= relativeRoot %>/docs/css/bootstrap-light.css">
    <link rel="stylesheet" type="text/css" href="<%= relativeRoot %>/docs/css/syntaxHighlight.css">
    <link rel="stylesheet" type="text/css" href="<%= relativeRoot %>/docs/css/docs.css" media="screen">
    <link rel="stylesheet" type="text/css" href="<%= relativeRoot %>/docs/css/example.css" media="screen">
    <link rel="stylesheet" type="text/css" href="<%= relativeRoot %>/docs/css/print.css" media="print">
    
    <title>react-datum</title>
  </head>

  <!--  This file is generated by scripts/buildDocIndex-->

  <body class="<%= bodyClass %>">
    <script src='<%=relativeRoot %>/docs/vendor/jquery.min.js'></script>
    <script src="<%= relativeRoot %>/docs/vendor/underscore-min.js"></script>
    <script src="<%= relativeRoot %>/docs/vendor/backbone-min.js"></script>

    <script src="<%= relativeRoot %>/docs/vendor/react.min.js"></script>
    <script src="<%= relativeRoot %>/docs/vendor/react-dom.min.js"></script>
    <script src="<%= relativeRoot %>/docs/vendor/react-datum.min.js"></script>

    <script src="<%= relativeRoot %>/docs/examples/examplesMetadata.js"></script>
    
    <%= header %>
    
    <div class="main-content">
      <%= content %>
    </div>
  </body>
</html>