module DocumentationEditor
  class Page < ActiveRecord::Base

    validates_uniqueness_of :slug

    has_many :revisions, class_name: 'Revision', dependent: :destroy
    belongs_to :published_revision, class_name: 'Revision', foreign_key: 'published_revision_id'

    belongs_to :thumbnail, class_name: 'Image'

    after_create :add_first_revision

    def add_revision!(content, publish = false, author_id = nil)
      r = revisions.build
      r.author_id = author_id
      r.content = content
      r.save!
      if publish
        self.published_revision_id = r.id
        save!
      end
      r
    end

    def thumbnail_url
      thumbnail.try(:image).try(:url)
    end

    private
    def add_first_revision
      r = Revision.new
      r.content = "# FIXME\n\nLorem ipsum."
      self.revisions << r
    end

  end
end
