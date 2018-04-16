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
  
  **homepage**: is used as the href in the "View on Github" link
  
  
### bumbleDocs.js

Create a file named bumbleDocs.js or .coffee in your project root that module.exports the following attributes:

```coffeescript
  module.exports = 
    
    # Expects a project root relative image path that is the src for the image displayed 
    # in the upper left header.  
    logo: "img/docs/tilegrid.logo.png"

    # these get added to the css linked to the static examples and docs and copied to 
    # docs/css
    styleSheets: [{
      path: "css/docs/tilegridExample.css"
      media: "screen"
    }]

    # these will get added as script tags into the generated pages 
    scripts: [{
      path: "test/lib/kittenData.js"
      # can also include the type (defaults to text/javascript)
      # type: "someSillyScriptLanguage"
    },{
      path: "dist/tilegrid.js"
    }]
    
    
    apiDocs: {
      # in the generated API docs, you can have sections. documentation found in the 
      # sources returned by the path glob will be in the section with a header
      # and sections are rendered in the order below
      sections: [{
        label: "Tilegrid" 
        # this can be any glob supported by https://github.com/isaacs/node-glob
        path: "src/tilegrid/**/*"
      }]
    }

    examples: {
      # a base path for all examples (defaults to '$project_root/examples')
      root: 'examples'
      demos: [{
        # should be unique (gets used as a backbone id)
        id: "bigKittens"
        name: "Big Kittens Demo!"
        # path joined to examples.root 
        path: "tilegrid.jsx"
        # this can be as long as you need and include HTML
        description: "This demo shows off the variable height and width capabilities of the tiles.  ...with kittens!"
      }]    
    }
  ```
  Each examples gets its own html wrapper that enables it to be run statically and standalone for easy debugging.
  
  An example viewer app that has a list left, demo and code on the right layout is also created in docs/examples/index.html.
    

  
  
  
