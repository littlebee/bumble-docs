  <div class="demo-pane">
    <button class="more btn btn-primary" data-which="demo">Show More Demo!</button>
    <h3>The Demo:</h3> 
    <div id="demo">
      <!--  Example code uses this to render output -->
    </div>
  </div>
  <div class='code-pane'>
    <button class="more btn btn-primary" data-which="code">Show More Code!</button>
    <h3>The Code:</h3> 
    <%= sourceCode %>
  </div>
  
  <script src="<%= relativeRoot %>/test/lib/kittenData.js"></script>
  <script src="<%= sourceFile %>"></script>
  <script>
    $(function() {
      // window.Demo expected to be set by by sourceFile
      ReactDOM.render(React.createElement(window.Demo), document.getElementById('demo'))
      
      $('button.more').click(function(evt) { 
        $('body').attr("data-showmore", $(evt.target).attr('data-which')); 
      });
    });
  </script>
    
