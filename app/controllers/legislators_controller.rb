require "#{Rails.root}/lib/vendor_api/google_civic_api"

class LegislatorsController < ApplicationController
  include VendorAPI::GoogleCivic
  before_action :authenticate_user!

  def index
    legislator_names = Officials.names_from_address current_user.address.street_address
    last_names = legislator_names.map{ |name| name.split(' ').last }
    @legislators = Legislator.where(last_name: last_names)
  end
end
