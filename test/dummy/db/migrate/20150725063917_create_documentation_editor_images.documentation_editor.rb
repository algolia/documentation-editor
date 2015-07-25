# This migration comes from documentation_editor (originally 20150725063642)
class CreateDocumentationEditorImages < ActiveRecord::Migration
  def up
    create_table :documentation_editor_images do |t|
      t.string :caption
      t.datetime :created_at, null: false
    end
    add_attachment :documentation_editor_images, :image
  end

  def down
    remove_attachment :documentation_editor_images, :image
    drop_table :documentation_editor_images
  end
end
