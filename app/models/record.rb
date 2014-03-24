# Schema Information
#
# Table name: recrods
#
#    t.integer  "user_id"
#    t.float    "value"
#    t.text     "remark"
#    t.string   "ymdhms"
#    t.datetime "created_at"
#    t.datetime "updated_at"

class Record < ActiveRecord::Base

  belongs_to :user

  validate :user_id, presence: true
  validate :value, presence: true
  validate :ymdhms, presence: true

end
