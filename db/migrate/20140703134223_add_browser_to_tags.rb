class AddBrowserToTags < ActiveRecord::Migration
  def change
    add_column :tags, :browser, :string
  end
end
