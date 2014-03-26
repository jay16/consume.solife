# Schema Information
#
# Table name: record_with_tags
#
#    t.integer  "record_id"
#    t.integer  "tag_id"
#    t.datetime "created_at"
#    t.datetime "updated_at"
#
class RecordWithTag < ActiveRecord::Base

  validates :record_id, presence: true, numericality: { greater_than: 0 }
  validates :tag_id, presence: true, numericality: { greater_than: 0 }

  belongs_to :record
  belongs_to :tag
end
