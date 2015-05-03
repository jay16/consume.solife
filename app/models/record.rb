# encoding: utf-8
# Schema Information
#
# Table name: records
#
#    t.integer  "user_id"
#    t.float    "value"
#    t.text     "remark"
#    t.string   "ymdhms"
#    t.text     "items"
#    t.integer  "klass"  # cloth/food/house/foot/other
#    t.datetime "created_at"
#    t.datetime "updated_at"
class Record < ActiveRecord::Base
  attr_accessor :tags_list, :image
  
  validates :user_id, presence: true
  validates :value, presence: true
  validates :ymdhms, presence: true

  belongs_to :user, counter_cache: true
  has_and_belongs_to_many :tags, -> { uniq }, autosave: true
  
  scope :recent, -> { order("created_at desc") }
  scope :normals, -> { where(:deleted => false) }
  scope :deleted, -> { where(:deleted => true) }
  scope :undeleted, -> { where(:deleted != true) }

  # user report necessary
  scope :maximum_value_per_one, -> { maximum(:value) }
  scope :maximum_value_per_day, -> { select("sum(value) as value,str_to_date(ymdhms, '%Y-%m-%d') as ymd").group("ymd").order("value desc").first.value || 0 }
  scope :summary_value_by_day, -> { select("sum(value) as value").where("left(ymdhms, 10) = date_format(now(), '%Y-%m-%d')") }
  scope :summary_value_by_week, -> { select("sum(value) as value").where("weekofyear(str_to_date(ymdhms, '%Y-%m-%d')) = weekofyear(now())") }
  scope :summary_value_by_month, -> { select("sum(value) as value").where("left(ymdhms, 7) = date_format(now(), '%Y-%m')") }
  scope :summary_value_by_year,  -> { select("sum(value) as value").where("left(ymdhms, 4) = date_format(now(), '%Y')") }
  scope :summary_value_by_all, -> { sum(:value) }
 
  after_create :ymdhms_must_be_exist, :build_relation_with_tags
  after_update :build_relation_with_tags
  
  def klass_mapping
    { 1 => "衣", 2 => "食", 3 => "住", 4 => "行", -1 => "其他" }
  end

  def klass_name
    klass_mapping[self.klass]
  end

  def tags_list
    @tags_list || tags_string
  end

  def tags_string
    self.tags.map(&:label).join(",") 
  end

  def soft_delete
    self.update_column(:deleted, true)
  end

  def ymdhms_must_be_exist
    update_column(:ymdhms, created_at.strftime("%Y-%m-%d %H:%M:%S")) unless ymdhms
  end
  def build_relation_with_tags
    if self.tags_list.strip.empty?
      # clear all relation with tag
      self.tags.each { |tag| self.tags.delete(tag) } if !self.tags.empty?
    else
      tags = self.tags.map(&:label)
      # filter the nuuse tags
      self.tags_list.split(",").map(&:strip).uniq.each do |label|
        tag = self.user.tags.find_or_create_by(label: label, klass: self.klass)
        # rebuild relation with tags: remove unuse tags and add new tag
        tags.include?(label) ? tags.delete(label) : self.tags << tag
      end
      # remove the unuse tags relation
      tags.each { |l| self.tags.delete self.tags.find_by(label: l) } if !tags.empty?
    end
  end

end
