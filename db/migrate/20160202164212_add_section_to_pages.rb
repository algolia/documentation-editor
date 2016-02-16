class AddSectionToPages < ActiveRecord::Migration
  def change
    add_column :documentation_editor_pages, :section, :string
  end
end
