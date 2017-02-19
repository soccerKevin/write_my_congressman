class Legislator < ActiveRecord::Base
  has_one :address
  has_one :phone
  has_one :fax, class_name: 'Phone'

  validates :first_name, :last_name, :bio_id, :position, :party, :started, :state, presence: true

  def name
    "#{first_name} #{last_name}"
  end

  def image_name
    "#{first_name}_#{last_name}.jpg".downcase
  end

  def position_long
    case position
    when 'rep'
      'representative'
    when 'sen'
      'senator'
    when 'viceprez'
      'vice president'
    when 'prez'
      'president'
    else
      position
    end
  end
end
