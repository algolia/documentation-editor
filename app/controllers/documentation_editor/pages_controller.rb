require_dependency "documentation_editor/application_controller"

module DocumentationEditor
  class PagesController < ApplicationController
    skip_before_filter :verify_authenticity_token

    if DocumentationEditor::Config.is_admin_before_filter
      before_filter DocumentationEditor::Config.is_admin_before_filter, except: [:show]
    end

    def admin
    end

    def edit
      @page = Page.find(params[:id])
    end

    def source
      render json: (Page.find(params[:id]).content || 'FIXME').to_json
    end

    def save
      p = Page.new
      p.author_id = respond_to?(:current_user) ? current_user.id : nil
      p.slug = Page.find(params[:id]).slug
      p.preview = params[:preview]
      p.content = params[:data]
      p.save!
      render json: { id: p.id, slug: p.slug }
    end

    def create
      p = Page.new
      p.slug = params[:page][:slug]
      p.save!
      redirect_to edit_page_path(p)
    end

    def preview
      @page = Page.find(params[:id])
      @options = params
    end

    def show
      @page = Page.where(preview: false).where(slug: params[:slug]).order('id DESC').first!
      @options = params
      render :preview
    end

    def destroy
      Page.find(params[:id]).destroy
      redirect_to :admin
    end

    def upload_image
      image = Image.create(caption: params[:caption], image: params[:file])
      render json: { id: image.id, url: image.image.url }
    end
  end
end
