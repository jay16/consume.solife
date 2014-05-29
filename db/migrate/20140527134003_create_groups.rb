class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.integer :from_id
      t.integer :to_id
      t.boolean :accept, default: false, null: false
      t.string :state, default: "wait", null: false

      t.timestamps
    end
  end
end
