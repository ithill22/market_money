require 'rails_helper'

RSpec.describe Market, type: :model do
  before :each do
    test_data
  end

  describe 'relationships' do
    it { should have_many :market_vendors }
    it { should have_many(:vendors).through(:market_vendors) }
  end

  describe 'instance methods' do
    describe '#vendor_count' do
      it 'returns the number of vendors at a market' do
        expect(@market_1.vendor_count).to eq(5)
        expect(@market_2.vendor_count).to eq(2)
        expect(@market_3.vendor_count).to eq(0)
      end
    end
  end
end