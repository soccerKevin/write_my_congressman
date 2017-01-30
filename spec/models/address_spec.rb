require 'rails_helper'
require 'street_address'

RSpec.describe Address, type: :model do
  describe 'class methods' do
    describe 'from line' do
      it 'should take a string' do
        expect(Address.from_line("465 Andover Court, Gurnee, IL 60031").is_a? Address).to eq true
      end

      it 'should take a StreetAddress' do
        street_address = StreetAddress::US.parse "465 Andover Court, Gurnee, IL 60031"
        expect(Address.from_line(street_address).is_a? Address).to eq true
      end
    end
  end
end
