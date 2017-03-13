class Message < ActiveRecord::Base
  include ActiveModel::Validations
  belongs_to :address
  belongs_to :user

  has_many :legislators, through: :user
end
