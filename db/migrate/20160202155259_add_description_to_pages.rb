class AddDescriptionToPages < ActiveRecord::Migration
  def change
    add_column :documentation_editor_pages, :description, :string
  end
end
