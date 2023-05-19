require 'rails_helper'

RSpec.describe Market, type: :model do
  before :each do
    test_data
  end

  describe 'relationships' do
    it { should have_many :market_vendors }
    it { should have_many(:vendors).through(:market_vendors) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :street }
    it { should validate_presence_of :city }
    it { should validate_presence_of :county }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
    it { should validate_presence_of :lat }
    it { should validate_presence_of :lon }
  end

  describe 'class methods' do
    describe '::market_search' do
      it 'returns markets that match the search criteria' do
        market = Market.create!(name: 'Union Station Farmers Market', street: '1701 Wynkoop St', city: 'Denver', county: 'Denver', state: 'CO', zip: '80202', lat: '39.752831', lon: '-104.998331')
        market_2 = Market.create!(name: 'Cherry Creek Farmers Market', street: '1st Ave & University Blvd', city: 'Denver', county: 'Denver', state: 'CO', zip: '80206', lat: '39.717285', lon: '-104.952248')
        expect(Market.market_search('denver', 'co', 'union').count).to eq(1)
        expect(Market.market_search('denver', 'co', 'union')[0].name).to eq('Union Station Farmers Market')
      end
    end
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