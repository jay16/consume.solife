class AddIpToTags < ActiveRecord::Migration
  def change
    add_column :tags, :ip, :string
  end
end
