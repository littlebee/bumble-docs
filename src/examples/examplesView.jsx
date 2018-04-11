
var Rd = ReactDatum
var ReactTilegrid = Tilegrid.ReactTilegrid

// This is the source for the left-right iframe viewer used to
// view examples on our github.io pages like http://zulily.github.io/react-datum/docs/examples
//
// this file is created by bumble-docs if it doesn't exist in the docs/examples dir

// EXAMPLES_METADATA is loaded by the index.html from ./examplesMetadata.js which is generated
// by bumble-docs/scripts/buildExamples.coffee
var examplesCollection = new Backbone.Collection(EXAMPLES_METADATA.demos)


// Each of the demos are wrapped in their own .html which is generated using /src/docs/exampleFile.tpl  
// It makes each of them individually debuggable.  

class DemoIframe extends React.Component {
  static propTypes = {
    model: PropTypes.instanceOf(Backbone.Model)
  } 

  static contextTypes = {
    model: React.PropTypes.object
  }
  
  static childContextTypes = {
    model: PropTypes.instanceOf(Backbone.Model)
  }
  render() {
    var model = this.getModel()
    var srcPath = model.get('path')
    var htmlPath = srcPath.replace(/(.*)(\.jsx|\.js|\.coffee|\.cjsx)/, "$1.html")
    return <iframe src={htmlPath}/>
  }
  
  getModel() {
    return this.props.model || this.context.model
  }
}


class ExamplesView extends React.Component {
  render() {
    return (
      <div id="examplesView">
        <Rd.Collection collection={examplesCollection}>
          <ReactTilegrid>
            <Rd.LazyPhoto attr="thumbnailUrl"/>
            <h4><Rd.Text attr="name"/></h4>
            <div><Rd.Text attr="description" ellipsizeAt={false} displayAsHtml/></div>
          </ReactTilegrid>
          <div className="content-pane">
            <Rd.SelectedModel placeholder="Select a demo from the list on the left">
              <DemoIframe/>  
            </Rd.SelectedModel>
          </div>
        </Rd.Collection>
      </div>
    )
  }
  
  componentDidMount() {
    if( window && window.location && window.location.hash ){
      var idToSelect = window.location.hash.slice(1)
      _.delay(function(){examplesCollection.selectModelById(idToSelect)}, 1000)
    }
    examplesCollection.on('selectionsChanged', function(){
      var model = examplesCollection.getSelectedModels()[0]
      window.location.hash = model && model.id || ""
    })
  }  
}

if( window )
  window.Demo = ExamplesView
else if ( module )
  module.exports = ExamplesView
