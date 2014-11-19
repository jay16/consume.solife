class AddItemsToRecords < ActiveRecord::Migration
  def change
    add_column :records, :items, :text
  end
end
