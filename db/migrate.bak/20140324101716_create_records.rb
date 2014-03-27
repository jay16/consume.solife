class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.integer :user_id
      t.float :value
      t.text :remark
      t.string :ymdhms

      t.timestamps
    end
  end
end
