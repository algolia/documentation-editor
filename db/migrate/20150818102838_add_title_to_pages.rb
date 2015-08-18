class AddTitleToPages < ActiveRecord::Migration
  def change
    add_column :documentation_editor_pages, :title, :string, limit: 255
  end
end
