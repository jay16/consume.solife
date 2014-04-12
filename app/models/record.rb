# encoding: utf-8
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
  attr_accessor :tags_list, :image
  
  validates :user_id, presence: true
  validates :value, presence: true
  validates :ymdhms, presence: true

  belongs_to :user
  has_and_belongs_to_many :tags,-> { uniq }, autosave: true
  
  after_create :build_with_tags
  after_update :build_with_tags
  
  def klass_mapping
    { 1 => "衣", 2 => "食", 3 => "住", 4 => "行", -1 => "其他" }
  end

  def klass_name
    klass_mapping[self.klass]
  end

  def tags_list
    @tags_list || ""
  end

  def tags_string
    self.tags.map { |t| t.label }.join(",")
  end

  def tags_string
    self.tags.map { |t| t.label }.join(",") 
  end

  def build_with_tags
    return if self.tags_list.blank? or self.tags_list.chomp.size == 0
     
    tags = self.tags.map { |t| t.label }
    self.tags_list.split(",").map{ |t| t.strip }.uniq.each do |label|
       tag = self.user.tags.find_or_create_by(label: label)
       tags.include?(label) ? tags.delete(label) : self.tags << tag
    end
    tags.each { |l| self.tags.delete self.tags.find_by(label: l) } if !tags.empty?
  end
end
