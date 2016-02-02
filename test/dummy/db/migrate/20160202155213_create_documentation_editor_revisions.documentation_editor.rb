# This migration comes from documentation_editor (originally 20150728040718)
class CreateDocumentationEditorRevisions < ActiveRecord::Migration
  def change
    create_table :documentation_editor_revisions do |t|
      t.integer :page_id, null: false
      t.integer :author_id
      t.text :content, limit: 16777215
      t.datetime :created_at, null: false
    end
    add_column :documentation_editor_pages, :published_revision_id, :integer
    DocumentationEditor::Page.group('slug').having('MIN(id)').all.each do |p|
      DocumentationEditor::Page.where(slug: p.slug).find_each do |revision|
        r = DocumentationEditor::Revision.new
        r.page_id = p.id
        r.author_id = revision.author_id
        r.content = revision.content
        r.created_at = revision.created_at
        r.save!
        if !revision.preview
          p.published_revision_id = r.id
        end
      end
      p.save
      DocumentationEditor::Page.where(slug: p.slug).where.not(id: p.id).delete_all
    end
    remove_column :documentation_editor_pages, :content
    remove_column :documentation_editor_pages, :preview
  end
end
