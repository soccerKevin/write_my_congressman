require 'rails_helper'
describe ApplicationController do
  fixtures :users, :addresses

  describe 'user without address' do
    before :each do
      login_user
    end

    it "should have a current_user" do
      expect(subject.current_user.class.name).to eq 'User'
    end

    it 'should redirect to edit user' do
      route = controller.send :after_sign_in_path_for, @user
      expect(route).to eq "/users/#{@user.id}/edit"
    end
  end

  describe 'user with address' do
    before :each do
      login_user_with_address
    end

    it 'should redirect to /messages/new' do
      route = controller.send :after_sign_in_path_for, @user
      expect(route).to eq '/messages/new'
    end
  end
end
