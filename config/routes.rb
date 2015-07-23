DocumentationEditor::Engine.routes.draw do
  get "admin", :controller => 'pages', :action => 'admin'
  get "edit/:id", as: :edit_page, :controller => 'pages', :action => 'edit'
  get "source/:id", :controller => 'pages', :action => 'source'
  post 'source', :controller => 'pages', :action => 'create'
  post 'source/:id', :controller => 'pages', :action => 'save'
  post 'update', controller: 'pages', :action => 'update'
  get "preview/:id", :controller => 'pages', :action => 'preview'
  get ':slug', :controller => 'pages', :action => 'show', constraints: { slug: /.*/ }
end
