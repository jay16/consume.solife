class Group < ActiveRecord::Base
  #scope :mmbers, -> (id) { where(:from_id => id) }
  #scope :members, lambda {|user| where(:from_id => user.id)}
  belongs_to :user, class_name: 'User', foreign_key: :from_id
  belongs_to :ask_user, class_name: 'User', foreign_key: :to_id
  belongs_to :follow_user, class_name: 'User', foreign_key: :from_id


  def self.include?(user)
    where(:to_id => user.id).count
  end
end
