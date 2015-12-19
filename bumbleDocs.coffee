
module.exports = 
  
  logo: "docs/img/react-datum.logo.png",

  # these get added to the css linked to the static examples and docs and copied to 
  # docs/css
  styleSheets: [{
    path: "/css/docs/tilegridExample.css"
    media: "screen"
  }]

  scripts: [{
    path: "/test/lib/kittenData.js"
  }]
  
  apiDocs: {
    sections: [{
      label: "Datum Components" 
      path: "src/datums/**/*"
    },{
      label: "Contextual Components" 
      path: "src/*"
    }]
  }

  examples: 
    root: 'src/examples'
    demos: [{
      id: "model",
      name: "Model Demo",
      path: "model/model.jsx",
      description: "This demo shows how simple it is to create a display only form.", 
      thumbnailUrl: "http://zulily.github.io/react-datum/docs/img/react-datum_model-example.png",
    },{
      id: "form",
      name: "Form Demo",
      path: "form/form.jsx",
      description: "This demo shows how to create an input form that saves a Backbone model when "+
        "the user presses save.",
      thumbnailUrl: "http://zulily.github.io/react-datum/docs/img/react-datum_form-example.png",
    },{
      id: "bigKittens",
      name: "Big Kittens Demo!",
      path: "tilegrid/tilegrid.jsx",
      description: "This demo shows the pieces all come together to make a function CRUD app. " +
        "<br>...with Kittens!<br><br>Try maximizing your browser or zooming out.  The " +
        "tiles can be variable height and width or fixed via css.",
    },{
      id: "examplesView",
      name: "Demos Within Demos",
      path: "examplesView.jsx",
      description: "<p>This demo is this demo viewer!</p> " +
        "<p>The demo viewer you are looking at right now, is really just a ReactDatum Tilegrid, a few "+
        "datums and a custom iframe component.</p>"+
        "<p>Be careful you don't fall in the rabbit hole by clicking too deep. :)</p>" + 
        "<p>All joking and parlor tricks aside, if you scroll past the the static data, you "+
        "can see a nice example of how to make use of a contextually provided model in a custom "+
        "react component</p> ",
    }]    
