#encoding: utf-8
require Rails.root.join('config/initializers/devise_encryptor')
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

  ACCESSABLE_ATTRS = [:name, :address, :email, :gender, :password, :password_confirmation, :password_salt]
  #scope :members, lambda {|groups| groups.map { |g| where(:id => g.to_id) }}
  after_update :trigger_updated_at

  # 是否是管理员
  def admin?
    Setting.admin_emails.include?(self.email)
  end

  # 用户名称
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
    Record.where("user_id in (#{uids.uniq.join(',')})")
  end

  def self.validate(token)
    e, p = Utils::GrapeEncryptor.decode(token)

    if user = User.find_by(email: e) and user.valid_password?(p)
      return user 
    end
  end

  # only use in spec/grape_spec.rb
  def token
    Utils::GrapeEncryptor.encode(self.email, Utils::Encryptor.decode(self.encrypted_password))
  end

  private

  def trigger_updated_at
    self.update_column(:updated_at, Time.now)
  end
end
