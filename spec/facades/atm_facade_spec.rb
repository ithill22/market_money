require 'rails_helper'

RSpec.describe AtmFacade do
  describe 'instance methods', :vcr do
    it '#atm_details' do
      market = Market.create!(name: 'Union Station Farmers Market', street: '1701 Wynkoop St', city: 'Denver', county: 'Denver', state: 'CO', zip: '80202', lat: '39.752831', lon: '-104.998331')
      facade = AtmFacade.new(market)

      expect(facade.atm_details).to be_a(Array)
      facade.atm_details.each do |atm|
        expect(atm).to be_a(Atm)
        expect(atm.lat).to be_a(Float)
        expect(atm.lon).to be_a(Float)
        expect(atm.distance).to be_a(Float)
        expect(atm.name).to be_a(String)
        expect(atm.address).to be_a(String)
      end
    end
  end
end