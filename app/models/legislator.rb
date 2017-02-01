class Legislator < ActiveRecord::Base
  has_one :address
  has_one :phone
  has_one :fax, class_name: 'Phone'

  validates :first_name, :last_name, :bio_id, :position, :party, :started, :state, presence: true
end
