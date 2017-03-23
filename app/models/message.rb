class Message < ActiveRecord::Base
  include ActiveModel::Validations
  has_and_belongs_to_many :legislators
  validates_presence_of :subject, :body, :name, :email, :address_line, :city, :state, :zip

  def send_email()
    require "#{Rails.root}/lib/vendor_api/congress_forms_api"
    legislators.each do |leg|
      form = VendorAPI::CongressForms.get_form leg.bio_id
      binding.pry
    end
  end
end
