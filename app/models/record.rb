# Schema Information
#
# Table name: rorrods
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
  has_and_belongs_to_many :tags,-> { uniq }, autosave: true
  
  after_create :build_with_tags

  private

  def build_with_tags
    return if self.tags_list.blank? or self.tags_list.chomp.size == 0

    self.tags_list.split(",").map{ |t| t.strip }.uniq.each do |str|
       self.tags << self.user.tags.find_or_create_by(label: str)
    end
  end
end
