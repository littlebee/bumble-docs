React = require('react')
_ = require('underscore')

Util = require('./lib/util')

module.exports = class Header extends React.Component
  
  render: =>
    # relativeRoot is the relative path to root for the file being generated 
    <header>
      <div>
        {@renderLogo()}
        <em>{@props.npmPackage?.description || ""}</em>
      </div>
      {@renderTabs()}
      {@renderGithubLink()}
    </header>
    
    
  renderLogo: =>   # ... or not
    if @props.configFile?.logo
      logoFile = Util.urlJoin @props.relativeRoot, @props.configFile.logo
      return <img src={logoFile} href="/docs"/>
    else 
      return <h1>{@props.npmPackage?.name || ""}</h1>
      
      
  renderGithubLink: =>
    return null unless @props.npmPackage?.repository?.url?
    <a className='github-link no-print' href={@props.npmPackage.homepage} target="blank">
      View on Github
    </a>
    
    
  renderTabs: =>
    renderedTabs = for tab,index in @getTabsToRender()
      fullRelativePath = Util.urlJoin @props.relativeRoot, tab.path
      className = 'main-menu-item'
      className += ' selected' if @props.selectedTab == tab.path
      <a className={className} href={fullRelativePath} key="tab-#{index}">{tab.title} </a>
    
    <div className='main-menu no-print'>
      {renderedTabs}
    </div>


  getTabsToRender: =>
    tabs = [{
      path: "/docs" 
      title: "Introduction and Getting Started"
    }]
    if @props.configFile.examples?
      tabs.push {
        path: "/docs/examples"
        title: "Live Demo & Examples"
      }
    if @props.configFile.apiDocs? 
      tabs.push {  
        path: "/docs/api"
        title: "API Docs"
      }
    return tabs
    
    
    