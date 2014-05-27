class Group < ActiveRecord::Base
  #scope :mmbers, -> (id) { where(:from_id => id) }
  #scope :members, lambda {|user| where(:from_id => user.id)}
  belongs_to :user
end
