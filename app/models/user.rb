class User < ActiveRecord::Base
  has_paper_trail

  has_many :authentications, class_name: 'UserAuthentication', dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :address
  has_many :messages

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

  def legislators
    return [] unless self.address.persisted?
    require "#{Rails.root}/lib/vendor_api/google_civic_api"
    legislator_names = VendorAPI::GoogleCivic::Officials.names_from_address self.address.street_address
    last_names = legislator_names.map{ |name| name.split(' ').last }
    @legislators = Legislator.where(last_name: last_names)
  end
end
