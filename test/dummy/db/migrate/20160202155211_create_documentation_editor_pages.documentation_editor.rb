# This migration comes from documentation_editor (originally 20150722230424)
class CreateDocumentationEditorPages < ActiveRecord::Migration
  def change
    create_table :documentation_editor_pages do |t|
      t.integer :author_id
      t.boolean :preview
      t.string :slug
      t.text :content, limit: 16777215
      t.datetime :created_at, null: false
    end
    add_index :documentation_editor_pages, :slug
    add_index :documentation_editor_pages, [:slug, :preview]
  end
end
