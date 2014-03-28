class CreateRecordsTags < ActiveRecord::Migration
  def change
    create_table :records_tags do |t|
      t.integer :record_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
