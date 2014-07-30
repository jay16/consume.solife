#encoding: utf-8
require Rails.root.join('config/initializers/devise_encryptor')
require "base64"
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable,
         :encryptable, :timeoutable, :timeout_in => 20.minutes

  #attr_accessor :name
  #attr_accessible :name
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@]+@[^@]+\z/, message: "Error Format Email!" }
  validates :password, length: { minimum: 6 } #minimum,maximum,is #in: 6..20

  has_many :tags, -> { uniq }
  has_many :records, -> { uniq }

  has_many :follow_groups, -> { where accept: false }, class_name: 'Group', foreign_key: :to_id
  has_many :ask_groups, -> { where accept: false }, class_name: 'Group', foreign_key: :from_id

  has_many :_ask_groups, -> { where accept: true }, class_name: 'Group', foreign_key: :from_id
  has_many :group_users, through: :_ask_groups, source: :ask_user

  has_many :_follow_groups, -> { where accept: true }, class_name: 'Group', foreign_key: :to_id
  has_many :group_follows, through: :_follow_groups, source: :follow_user

  #scope :members, lambda {|groups| groups.map { |g| where(:id => g.to_id) }}

  # 是否是管理员
  def admin?
    Setting.admin_emails.include?(self.email)
  end

  def username
    self.name || "未设置名称"
  end

  # uniq group_users and group_follows
  def group_members
    (group_users + group_follows).uniq
  end

  def group_member_records(whether_include_self = true)
    uids = group_members.map { |u| u.id }
    uids.push(id) if whether_include_self
    Record.where("user_id in (#{uids.join(',')})")
  end

  def self.validate(token)
    str = Base64.decode64(token)
    n1 = str[0].to_i
    n2 = str[1..n1]
    str = str[n1+n2.length-1..str.length-1]

    email = str[0..n2.to_i-1]
    pwd   = str[n2.to_i..str.length-1]
    if user = User.find_by(email: email)
       return user if user.valid_password?(pwd)
    end
  end

  # only use in spec/grape_spec.rb
  def token
    self.password ||= "jay527130673"
    n2 = self.email.length.to_s
    n1 = n2.length.to_s
    str = n1 + n2 + self.email + self.password
    Base64.encode64(str).strip
  end
end


