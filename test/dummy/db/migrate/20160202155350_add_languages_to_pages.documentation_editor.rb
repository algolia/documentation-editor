# This migration comes from documentation_editor (originally 20160202155254)
class AddLanguagesToPages < ActiveRecord::Migration
  def change
    add_column :documentation_editor_pages, :languages, :string
  end
end
