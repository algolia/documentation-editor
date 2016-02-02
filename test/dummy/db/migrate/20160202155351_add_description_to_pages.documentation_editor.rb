# This migration comes from documentation_editor (originally 20160202155259)
class AddDescriptionToPages < ActiveRecord::Migration
  def change
    add_column :documentation_editor_pages, :description, :string
  end
end
