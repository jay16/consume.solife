class RecordWithTag < ActiveRecord::Base

  validates :record_id, presence: true
  validates :tag_id, presence: true

  belongs_to :record
  belongs_to :tag
end
