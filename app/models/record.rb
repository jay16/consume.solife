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
  attr_accessor :tags_list
  
  validates :user_id, presence: true
  validates :value, presence: true
  validates :ymdhms, presence: true

  belongs_to :user
  has_many :record_with_tags, dependent: :destroy
  has_many :tags, through: :record_with_tags

  before_save :build_with_tags
  def build_with_tags
    return if self.tags_list.blank?

    self.tags_list.split(",").each do |str|
      tag = current_user.tags.find_or_create(:label, str.chomp)

    end
  end
end
