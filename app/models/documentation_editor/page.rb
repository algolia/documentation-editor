module DocumentationEditor
  class Page < ActiveRecord::Base

    validates_uniqueness_of :slug

    has_many :revisions, class_name: 'Revision', dependent: :destroy
    belongs_to :published_revision, class_name: 'Revision', foreign_key: 'published_revision_id'

    def add_revision!(content, publish = false, author_id = nil)
      r = revisions.build
      r.author_id = author_id
      r.content = content
      r.save!
      update_attributes(published_revision_id: r.id) if publish
      r
    end

  end
end
