class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :from_id
      t.integer :to_id
      t.boolean :state, default: false, null: false

      t.timestamps
    end
  end
end
