class User < ActiveRecord::Base
  has_many :authentications, class_name: 'UserAuthentication', dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :address
  accepts_nested_attributes_for :address

  # validates :first_name, :last_name, :address, :email, presence: true
  validates_associated :address

  def self.create_from_omniauth(params)
    info = params['info']

    create({
      email: info['email'],
      password: Devise.friendly_token,
      first_name: info['first_name'],
      last_name: info['last_name']
    })
  end
end
