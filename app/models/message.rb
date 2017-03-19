class Message < ActiveRecord::Base
  include ActiveModel::Validations
  has_and_belongs_to_many :legislators
end
