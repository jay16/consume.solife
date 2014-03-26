# Schema Information
#
# Table name: tags
#
#    t.integer  "user_id"
#    t.string   "label"
#    t.datetime "created_at"
#    t.datetime "updated_at"#
class Tag < ActiveRecord::Base

  validate label, presence: true, length: { minimum: 1 }

  belongs_to :record
  validates :record, presence: true
end
