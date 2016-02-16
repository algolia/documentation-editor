class AddLanguagesToPages < ActiveRecord::Migration
  def change
    add_column :documentation_editor_pages, :languages, :string
  end
end
