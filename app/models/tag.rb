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
  #uniq: true, scope: :user

  belongs_to :user, counter_cache: true
  has_and_belongs_to_many :records,-> { uniq }, autosave: true

  scope :recent, -> { order("created_at desc") }
  scope :deleted, -> { where(:deleted => true) }
  scope :undeleted, -> { where(:deleted => false) }
  scope :normals, -> { where(:deleted => false) }

  def klass_mapping
    { 1 => "衣", 2 => "食", 3 => "住", 4 => "行", -1 => "其他" }
  end

  def klass_name
    klass_mapping[self.klass]
  end

  def soft_delete
    self.update_column(:deleted, true)
  end
end
