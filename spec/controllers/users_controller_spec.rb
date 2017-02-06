require 'rails_helper'

describe UsersController do
  fixtures :users

  before :each do
    login_user
  end

  describe 'update user' do
    it 'adds an address' do
      address_attributes = {
        line: "208 Manhattan St.",
        city: 'Auburndale',
        state: 'FL',
        zip: '33823'
      }
      post :update, id: @user.id, user: { address_attributes: address_attributes }
      address = User.find(@user.id).address
      expect(address.line).to eq "208 Manhattan St."
    end
  end
end
