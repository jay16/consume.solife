class AddColumnsToTags < ActiveRecord::Migration
  def change
    add_column :tags, :klass, :integer, default: -1, null: false
  end
end
