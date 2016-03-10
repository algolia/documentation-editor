Rails.application.routes.draw do

  get '/doc/ruby(/:section)', controller: 'documentation_editor/pages', action: 'show', slug: 'guide', language: 'ruby'
  get '/doc/javascript(/:section)', controller: 'documentation_editor/pages', action: 'show', slug: 'guide', language: 'js'
  get '/doc/guide/:language', controller: 'documentation_editor/pages', action: 'show', slug: 'guide'
  mount DocumentationEditor::Engine => "/doc"

end
