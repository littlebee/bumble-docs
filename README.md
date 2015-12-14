# bumble-docs
API and examples documentation generator that probably won't work with your code :)

This is the api documentation and examples generator I built (with help from lots of other packages - thank you!).  It is used to generate the static github.io docs for [react-datum](http://zulily.github.io/react-datum/docs/) and, *coming soon*, react-tilegrid.

I didn't want to wholesale copy the code for the docs generation between projects / repos that were split out from react-datum. 

This seriously, probably will not work for you.   If you are writing in coffeescript and cjsx, have examples in cjsx or jsx it may work for you, but no gurantees.  Fork you!  I mean me, Fork me!

### package.json

Some of the configurable variables of the generated docs, come from the package.json file.  

##### Standard package.json attributes used:
  
  **name**:   The name of the package is used as the page title.  
  
  **description**: is displayed in the header upper right the documentation generation 
  
  **repository.url**: is used as the href in the "View on Github" link
  
  
### bumbleDocs.js

Create a file named bumbleDocs.js or .coffee in your project root that module.exports the following attributes:
  
  **logo**: Expects a project root relative image path that is the src for the image displayed in the upper left header. ex: `logo: "img/logo.png"` should find and use the logo.png file
  
  **examples**: Expects an array of objects, each with the attributes: 
    [{
      // a unique id please
      id: "model",
      // name to display in viewer tile
      name: "Model Demo",
      // path to the src file for the demo
      path: "src/docs/examples/model.html",
      // this can be html - describe the demo and tell user about interesting features
      description: "This demo shows how simple it is to create a display only form.", 
      // a thumbnail image of the working demo 
      thumbnailUrl: "http://zulily.github.io/react-datum/docs/img/react-datum_model-example.png",
    }]
    
    Each examples gets its own html wrapper that enables it to be run statically and standalone for easy debugging.
    
    An example viewer app that has a list left, demo and code on the right layout is also created in docs/examples/index.html.
    
    
  
  
  
