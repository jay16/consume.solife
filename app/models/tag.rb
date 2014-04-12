#encoding: utf-8
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
  has_and_belongs_to_many :records,-> { uniq }, autosave: true

  def klass_mapping
    { 1 => "衣", 2 => "食", 3 => "住", 4 => "行", -1 => "其他" }
  end

  def klass_name
    klass_mapping[self.klass]
  end
end
