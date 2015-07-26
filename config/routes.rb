DocumentationEditor::Engine.routes.draw do
  scope path: '/admin' do
    get '/', as: :admin, :controller => 'pages', :action => 'index'
    post '/', :controller => 'pages', :action => 'create'

    get '/:id', :controller => 'pages', :action => 'source'
    get '/:id/edit', as: :edit_page, :controller => 'pages', :action => 'edit'
    post '/:id', :controller => 'pages', :action => 'update'
    delete '/:id', as: :delete_page, :controller => 'pages', :action => 'destroy'
    get '/:id/preview', as: :preview_page, :controller => 'pages', :action => 'preview'

    post '/images', as: :upload_image, :controller => 'pages', :action => 'upload_image'
  end

  get '/:slug', as: :page, :controller => 'pages', :action => 'show', constraints: { slug: /.*/ }
end
