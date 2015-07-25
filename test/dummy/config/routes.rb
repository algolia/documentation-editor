Rails.application.routes.draw do

  get '/doc/ruby', controller: 'documentation_editor/pages', action: 'show', slug: 'ruby', condition: 'ruby', language: 'ruby'
  mount DocumentationEditor::Engine => "/doc"

end
