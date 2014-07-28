class AddTagsCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :tags_count, :integer, :default => 0

    User.reset_column_information
    User.all.each do |u|
      User.update_counters u.id, :tags_count => u.tags.count
    end
  end
end
