require_dependency "documentation_editor/application_controller"

module DocumentationEditor
  class PagesController < ApplicationController
    skip_before_filter :verify_authenticity_token

    if DocumentationEditor::Config.is_admin
      before_filter except: [:show] do |controller|
        controller.instance_eval do
          if !DocumentationEditor::Config.is_admin
            redirect_to '/'
            return false
          end
        end
      end
    end

    before_filter :setup_page, only: [:edit, :source, :update, :preview, :destroy, :history, :versions]

    def index
    end

    def edit
    end

    def source
      render json: { source: (@page.revisions.last.try(:content) || 'FIXME') }
    end

    def update
      r = @page.revisions.build
      r.author_id = respond_to?(:current_user) ? current_user.id : nil
      r.content = params[:data]
      r.save!
      @page.published_revision_id = r.id if !params[:preview]
      @page.save!
      render nothing: true
    end

    def create
      p = Page.new
      p.slug = params[:page][:slug]
      p.save!
      redirect_to edit_page_path(p)
    end

    def preview
      @revision = @page.revisions.last
      @options = params
    end

    def show
      @page = Page.find_by(slug: params[:slug])
      @revision = @page.published_revision
      @options = params
      render :preview
    end

    def destroy
      @page.destroy
      redirect_to :admin
    end

    def upload_image
      image = Image.new
      image.caption = params[:caption]
      image.image = params[:file]
      image.save!
      render json: { id: image.id, url: image.image.url }
    end

    def history
    end

    def versions
      render json: { revisions: @page.revisions.order('id DESC').all }
    end

    def diff
      render inline: Diffy::Diff.new(Revision.find(params[:prev]).content, Revision.find(params[:cur]).content, context: 5, include_plus_and_minus_in_html: true, include_diff_info: true).to_s(:html)
    end

    private
    def setup_page
      @page = Page.find(params[:id])
    end
  end
end
