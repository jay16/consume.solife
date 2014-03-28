class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@]+@[^@]+\z/, message: "Error Format Email!" }
  validates :password, length: { in: 6..20 } #minimum,maximum,is

  has_many :tags, -> { uniq }
  has_many :records, -> { uniq }
end


