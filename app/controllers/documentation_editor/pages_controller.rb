require_dependency "documentation_editor/application_controller"

module DocumentationEditor
  class PagesController < ApplicationController
    skip_before_filter :verify_authenticity_token

    if DocumentationEditor::Config.is_admin
      before_filter except: [:show] do |controller|
        controller.instance_eval do
          if !controller.send(DocumentationEditor::Config.is_admin)
            redirect_to '/'
            false
          end
        end
      end
    end

    if DocumentationEditor::Config.before_filter
      before_filter DocumentationEditor::Config.before_filter, only: [:preview, :show]
    end

    before_filter :setup_page, only: [:edit, :source, :update, :commit, :preview, :destroy, :history, :versions, :upload_thumbnail]

    def index
    end

    def edit
    end

    def source
      render json: { source: (@page.revisions.last.try(:content) || 'FIXME') }
    end

    def update
      @page.position = params[:page][:position] unless params[:page][:position].nil?
      @page.title = params[:page][:title] unless params[:page][:title].nil?
      @page.slug = params[:page][:slug] unless params[:page][:slug].nil?
      @page.description = params[:page][:description] unless params[:page][:description].nil?
      @page.languages_raw = params[:page][:languages_raw] unless params[:page][:languages_raw].nil?
      @page.section = params[:page][:section] unless params[:page][:section].nil?
      @page.save!
      render nothing: true
    end

    def commit
      r = @page.add_revision!(params[:data], params[:preview].to_s == 'false', respond_to?(:current_user) ? current_user.id : nil)
      render json: { id: r.id }
    end

    def create
      p = Page.new
      p.author_id = respond_to?(:current_user) ? current_user.id : nil
      p.title = params[:page][:title]
      p.slug = params[:page][:slug]
      p.description = params[:page][:description]
      p.languages_raw = params[:page][:languages_raw]
      p.section = params[:page][:section]
      p.save!
      redirect_to edit_page_path(p)
    end

    def preview
      @revision = @page.revisions.last
      @options = params
    end

    def show
      @page = Page.find_by(slug: params[:slug])
      if @page.nil? && params[:language].nil? && params[:slug] && (p = params[:slug].rindex '/')
        @page = Page.find_by!(slug: params[:slug][0..(p - 1)])
        params[:language] = params[:slug][(p + 1)..-1]
      end
      @revision = @page.published_revision
      raise ActiveRecord::RecordNotFound.new if @revision.nil?

      @options = params
      @base_path = if params[:section]
        s = request.path.split('/')
        s.pop
        s.join('/')
      else
        request.path
      end
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
      render json: { id: image.id, url: image.image.url, caption: image.caption }
    end

    def upload_thumbnail
      thumb = @page.build_thumbnail
      thumb.image = params[:file]
      @page.save!
      render json: { id: thumb.id, url: thumb.image.url }
    end

    def history
    end

    def versions
      render json: { revisions: @page.revisions.order('id DESC').all }
    end

    def diff
      render inline: Diffy::Diff.new(Revision.find(params[:prev]).content, Revision.find(params[:cur]).content, context: 5, include_plus_and_minus_in_html: true, include_diff_info: true).to_s(:html)
    end

    def export
      pages = Page.all.map do |p|
        {
          slug: p.slug,
          created_at: p.created_at,
          title: p.title,
          languages: p.languages,
          description: p.description,
          section: p.section,
          position: p.position,
          content: p.revisions.last.try(:content)
        }
      end
      send_data JSON.pretty_generate(pages), type: :json, disposition: 'attachment', filename: "export-#{DateTime.now}.json"
    end

    def import
      JSON.parse(params[:file][:content].read).each do |page|
        p = Page.where(slug: page['slug']).first || Page.new
        p.slug = page['slug']
        p.created_at = page['created_at']
        p.title = page['title']
        p.languages = page['langauges']
        p.description = page['description']
        p.section = page['section']
        p.position = page['position']
        p.save!
        p.add_revision!(page['content'], true)
      end
      redirect_to :admin
    end

    private
    def setup_page
      @page = Page.find(params[:id])
    end
  end
end
