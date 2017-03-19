class Legislator < ActiveRecord::Base
  has_one :address
  has_one :phone
  has_one :fax, class_name: 'Phone'

  has_and_belongs_to_many :messages

  validates :first_name, :last_name, :bio_id, :position, :party, :started, :state, presence: true

  def name
    "#{first_name} #{last_name}"
  end

  def image_name
    "#{first_name}_#{last_name}.jpg".downcase
  end

  POSITIONS = {
    rep:      'representative',
    sen:      'senator',
    viceprez: 'vice president',
    prez:     'president'
  }
  def position_long
    POSITIONS[position.to_sym] || position
  end
end
