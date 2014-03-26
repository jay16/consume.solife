# Schema Information
#
# Table name: tags
#
#    t.integer  "user_id"
#    t.string   "label"
#    t.datetime "created_at"
#    t.datetime "updated_at"#
class Tag < ActiveRecord::Base
  validates :label, presence: true, length: { minimum: 1 }

  belongs_to :user
  has_many :record_with_tags, dependent: :destroy
  has_many :records, -> { distinct }, through: :record_with_tags
end
