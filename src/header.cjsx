React = require('react')
_ = require('underscore')

Util = require('./lib/util')

module.exports = class Header extends React.Component

  tabs: [{
    path: "/docs" 
    title: "Introduction and Getting Started"
  },{
    path: "/docs/examples"
    title: "Live Demo & Examples"
  },{  
    path: "/docs/api"
    title: "API Docs"
  }]

  render: =>
    # relativeRoot is the relative path to root for the file being generated 
    logoFile = Util.urlJoin @props.relativeRoot, @props.configFile.logo
    <header>
      <div>
        <img src={logoFile} href="/docs"/>
        <em>{@props.npmPackage.description}</em>
      </div>
      <div className='main-menu no-print'>
        {@renderTabs()}
      </div>
      <a className='github-link no-print' href={@props.npmPackage.repository.url} target="blank">
        View on Github
      </a>

    </header>
    
  renderTabs: =>
    renderedTabs = for tab,index in @tabs
      fullRelativePath = Util.urlJoin @props.relativeRoot, tab.path
      <a className='main-menu-item' href={fullRelativePath} key="tab-#{index}">{tab.title} </a>
    return renderedTabs

    