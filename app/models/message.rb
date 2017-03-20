class Message < ActiveRecord::Base
  include ActiveModel::Validations
  has_and_belongs_to_many :legislators
  validates_presence_of :subject, :body, :name, :email, :address_line, :city, :state, :zip
end
