# This migration comes from documentation_editor (originally 20160202164212)
class AddSectionToPages < ActiveRecord::Migration
  def change
    add_column :documentation_editor_pages, :section, :string
  end
end
