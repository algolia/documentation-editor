DocumentationEditor::Engine.routes.draw do
  scope path: '/admin' do
    get '/', as: :admin, :controller => 'pages', :action => 'index'
    post '/', :controller => 'pages', :action => 'create'

    post '/images', as: :upload_image, :controller => 'pages', :action => 'upload_image'

    get '/:id', :controller => 'pages', :action => 'source'
    get '/:id/edit', as: :edit_page, :controller => 'pages', :action => 'edit'
    put '/:id', as: :update, :controller => 'pages', :action => 'update'
    post '/:id', :controller => 'pages', :action => 'commit'
    delete '/:id', as: :delete_page, :controller => 'pages', :action => 'destroy'
    get '/:id/preview', as: :preview_page, :controller => 'pages', :action => 'preview'
    get '/:prev/:cur/diff', :controller => 'pages', :action => 'diff'
    get '/:id/history', as: :history, :controller => 'pages', :action => 'history'
    get '/:id/versions', :controller => 'pages', :action => 'versions'
  end

  get '/:slug', as: :page, :controller => 'pages', :action => 'show', constraints: { slug: /.*/ }
end
