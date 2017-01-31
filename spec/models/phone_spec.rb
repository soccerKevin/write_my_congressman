require 'rails_helper'

RSpec.describe Phone, type: :model do
  describe 'class methods' do
    it 'should fail on an invalid number' do
      begin
        Phone.create({ number: '1l23jldjf' })
        fail
      rescue
        pass
      end
    end

    it 'should save with a good number' do
      Phone.create({ number: '1-202-555-0137' }) rescue fail
      pass
    end
  end
end
