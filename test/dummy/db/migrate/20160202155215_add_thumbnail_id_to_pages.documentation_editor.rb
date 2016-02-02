# This migration comes from documentation_editor (originally 20150903121913)
class AddThumbnailIdToPages < ActiveRecord::Migration
  def change
    add_column :documentation_editor_pages, :thumbnail_id, :integer
  end
end
