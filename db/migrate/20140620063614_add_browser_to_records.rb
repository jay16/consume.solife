class AddBrowserToRecords < ActiveRecord::Migration
  def change
    add_column :records, :browser, :string
  end
end
