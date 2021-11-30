class AddSvgiconToCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :svg_icon, :text
  end
end
