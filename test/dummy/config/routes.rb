Rails.application.routes.draw do

  get '/doc/ruby', controller: 'documentation_editor/pages', action: 'show', slug: 'ruby', language: 'ruby'
  get '/doc/javascript', controller: 'documentation_editor/pages', action: 'show', slug: 'ruby', language: 'js'
  mount DocumentationEditor::Engine => "/doc"

end
