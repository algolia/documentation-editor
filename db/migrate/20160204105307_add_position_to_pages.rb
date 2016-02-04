class AddPositionToPages < ActiveRecord::Migration
  def change
    add_column :documentation_editor_pages, :position, :integer
  end
end
