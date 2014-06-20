class AddIpToRecords < ActiveRecord::Migration
  def change
    add_column :records, :ip, :string
  end
end
