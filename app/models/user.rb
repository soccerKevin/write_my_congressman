class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :address
  accepts_nested_attributes_for :address

  validates :first_name, :last_name, :address, :email, presence: true
  validates_associated :address
end
