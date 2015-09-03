class AddThumbnailIdToPages < ActiveRecord::Migration
  def change
    add_column :documentation_editor_pages, :thumbnail_id, :integer
  end
end
