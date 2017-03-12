class Message < ActiveRecord::Base
  belongs_to :address
  belongs_to :user

  has_many :legislators, through: :user
end
