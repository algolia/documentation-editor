module DocumentationEditor
  class Page < ActiveRecord::Base

    validates_uniqueness_of :slug

    has_many :revisions, class_name: 'Revision', dependent: :destroy
    belongs_to :published_revision, class_name: 'Revision', foreign_key: 'published_revision_id'

  end
end
