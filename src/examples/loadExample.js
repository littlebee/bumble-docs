$(function() {
  // window.Demo expected to be set by by sourceFile
  ReactDOM.render(React.createElement(window.Demo), document.getElementById('demo'))
  
  $('button.more').click(function(evt) { 
    $('body').attr("data-showmore", $(evt.target).attr('data-which')); 
  });
});