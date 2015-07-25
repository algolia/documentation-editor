module DocumentationEditor
  class Image < ActiveRecord::Base
    has_attached_file(:image, DocumentationEditor::Config.paperclip_option || {})
    validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  end
end
