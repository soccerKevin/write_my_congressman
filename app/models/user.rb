require 'human_name_parser'

class User < ActiveRecord::Base
  include ActiveModel::Validations
  has_paper_trail

  has_many :authentications, class_name: 'UserAuthentication', dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :address
  has_many :messages

  accepts_nested_attributes_for :address

  validates_presence_of :name, :email
  validates_presence_of :address, on: :update
  validates_associated :address, on: :update

  def self.create_from_omniauth(params)
    info = params['info']

    create({
      email: info['email'],
      password: Devise.friendly_token,
      name: "#{info['first_name']} #{info['last_name']}"
    })
  end

  def legislators
    address.legislators
  end

  def parser
    @parser ||= HumanNameParser.parse name
  end

  def first_name
    parser&.first
  end

  def last_name
    parser&.last
  end
end
