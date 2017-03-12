require "#{Rails.root}/lib/vendor_api/google_civic_api"

class LegislatorsController < ApplicationController
  before_action :authenticate_user!

  def index
    @legislators = current_user.legislators
  end
end
