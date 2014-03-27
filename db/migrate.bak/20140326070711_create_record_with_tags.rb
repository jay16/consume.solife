class CreateRecordWithTags < ActiveRecord::Migration
  def change
    create_table :record_with_tags do |t|
      t.integer :record_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
