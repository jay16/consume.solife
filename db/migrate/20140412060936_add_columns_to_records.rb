class AddColumnsToRecords < ActiveRecord::Migration
  def change
    add_column :records, :klass, :integer, default: -1, null: false
  end
end
