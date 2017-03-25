class LegislatorsController < ApplicationController
  before_action :authenticate_user!

  def index
    @legislators = current_user.legislators
  end
end
