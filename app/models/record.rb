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
  
  #after_create :build_with_tags
  #private
  def build_with_tags
    return if self.tags_list.blank? or self.tags_list.chomp.size == 0

    self.tags_list.split(",").each do |str|
       tag = self.user.tags.find_or_create_by(label: str.strip)
       RecordWithTag.create({record_id: self.id, tag_id: tag.id})
    end
  end
end
