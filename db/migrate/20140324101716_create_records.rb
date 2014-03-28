class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.belongs_to :user
      t.float :value
      t.text :remark
      t.string :ymdhms

      t.timestamps
    end
  end
end
