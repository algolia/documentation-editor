# This migration comes from documentation_editor (originally 20160204105307)
class AddPositionToPages < ActiveRecord::Migration
  def change
    add_column :documentation_editor_pages, :position, :integer
  end
end
