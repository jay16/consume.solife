class AddRecordsCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :records_count, :integer, :default => 0

    User.reset_column_information
    User.all.each do |u|
      User.update_counters u.id, :records_count => u.records.count
    end
  end
end
