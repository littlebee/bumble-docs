# bumble-docs
API and examples documentation generator that probably won't work with your code :)

This is the api documentation and examples generator I built (with help from lots of other packages - thank you!).  It is used to generate the static github.io docs for [react-datum](http://zulily.github.io/react-datum/docs/) and, *coming soon*, react-tilegrid.

I didn't want to wholesale copy the code for the docs generation between projects / repos that were split out from react-datum. 

This seriously, probably will not work for you.   If you are writing in coffeescript and cjsx, have examples in cjsx or jsx it may work for you, but no gurantees.  Fork you!  I mean me, Fork me!

### package.json

All of the configurable variables of the generated docs, come from the package.json file.  bumble-docs also will use some non-standard package.json attributes if they are available.

##### Standard package.json attributes used:
  
  name:   The name of the package is used as the page title.  
  description: is displayed in the header upper right the documentation generation 
  repository.url: is used as the href in the "View on Github" link
  
  
##### Non-standard package.json attributes used:
  
  logo: Expects a project root relative image path that is the src for the image displayed in the upper left header
  
  
