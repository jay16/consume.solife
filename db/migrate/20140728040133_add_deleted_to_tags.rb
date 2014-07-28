class AddDeletedToTags < ActiveRecord::Migration
  def change
    add_column :tags, :deleted, :boolean, :default => false
  end
end
