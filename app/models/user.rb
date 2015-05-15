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
  has_one  :user_report

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

  # group members consume report of yesterday default
  # cache every day for frequently call
  # `Rails.cache.clear` when need
  def group_member_report(num_day_ago=1, type="text")
    cache_key = "%d_group_member_records_ids_%s" % [id, num_day_ago.day.ago.strftime("%Y%m%d")]
    report = Rails.cache.fetch(cache_key) do
      ids =  group_member_records.where("left(ymdhms,10) = date_format(date_add(now(), interval -1 day), '%Y-%m-%d')").pluck(:id)

      report = Hash.new(0)
      report[:member] = group_members.map(&:name) + [name]
      report[:count]  = ids.count
      report[:value]  = ::Record.where("id in (?)", ids).sum(:value).to_i
      report # cache return 
    end

    case type
    when "text"
      report_consume_content = report[:count].zero? ? "无消费" : "笔数: #{report[:count]}\n总额: ￥#{report[:value]}"
      <<-`REPORT`
        echo 消费报告 #{1.day.ago.strftime('%m/%d %a')}\n
        echo 组员: #{report[:member].join(",")}
        echo #{report_consume_content} 
      REPORT
    when "json"
      report
    else
      report
    end
  end

  def update_user_report
    generate_user_report.update_columns(user_report_params)
  end

  def generate_user_report
    unless self.user_report
      self.user_report = UserReport.create(user_report_params)
    end
    self.user_report
  end

  # 用户名称
  def username
    name || "未设置名称<#{email}>"
  end

  # uniq group_users and group_follows
  def group_members
    (group_users + group_follows).uniq
  end

  def group_member_records(whether_include_self = true)
    uids = group_members.map { |u| u.id }
    uids.push(id) if whether_include_self
    ::Record.where("user_id in (?)", uids.uniq)
  end


  def has_role?(role)
    case role
      when :admin  then admin?
      when :member then !id.nil?
      else false
    end
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

  def user_report_params
    normal_records = self.records.normals
    normal_records_count = normal_records.count
    lambda_call_method = lambda { |method| normal_records_count.zero? ? 0 : normal_records.send(method) } 
    [:maximum_per_one,
     :maximum_per_day,
     :summary_by_day,
     :summary_by_week,
     :summary_by_month,
     :summary_by_year,
     :summary_by_all
     ].inject({}) { |hash, method| 
       hash[method] = lambda_call_method.call(method) 
       hash
     }
  end
end
