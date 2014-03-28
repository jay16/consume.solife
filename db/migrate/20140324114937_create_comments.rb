class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.belongs_to :user
      t.belongs_to :record
      t.text :content

      t.timestamps
    end
  end
end
