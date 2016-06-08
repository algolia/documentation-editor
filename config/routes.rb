DocumentationEditor::Engine.routes.draw do
  constraints format: 'html' do
    scope path: '/admin' do
      get '/', as: :admin, :controller => 'pages', :action => 'index'
      post '/', :controller => 'pages', :action => 'create'

      post '/images', as: :upload_image, :controller => 'pages', :action => 'upload_image'

      get '/export', as: :export, :controller => 'pages', :action => 'export'
      post '/import', as: :import, :controller => 'pages', :action => 'import'

      get '/:id', :controller => 'pages', :action => 'source'
      get '/:id/edit', as: :edit_page, :controller => 'pages', :action => 'edit'
      put '/:id', as: :update, :controller => 'pages', :action => 'update'
      post '/:id', :controller => 'pages', :action => 'commit'
      post '/:id/thumbnail', as: :upload_thumbnail, :controller => 'pages', :action => 'upload_thumbnail'
      delete '/:id', as: :delete_page, :controller => 'pages', :action => 'destroy'
      get '/:id/preview', as: :preview_page, :controller => 'pages', :action => 'preview'
      get '/:prev/:cur/diff', :controller => 'pages', :action => 'diff'
      get '/:id/history', as: :history, :controller => 'pages', :action => 'history'
      get '/:id/versions', :controller => 'pages', :action => 'versions'
    end

    get '/:slug/sections/:section', as: :section, :controller => 'pages', :action => 'show', constraints: { slug: /.*/ }
    get '/:slug', as: :page, :controller => 'pages', :action => 'show', constraints: { slug: /.*/ }
  end
end
