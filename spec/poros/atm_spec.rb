require 'rails_helper'

RSpec.describe Atm, type: :poro do
  describe 'initialize' do
    it 'exists and has attributes' do
      atm_data = {
        address: {freeformAddress: "1701 Wynkoop St, Denver, CO 80202"},
        dist: 0.0,
        poi: {name: "ATM"},
        position: {lat: "39.752831", lon: "-104.998331"}
      }
      atm = Atm.new(atm_data)
      
      expect(atm).to be_a(Atm)
      expect(atm.lat).to eq("39.752831")
      expect(atm.lon).to eq("-104.998331")
      expect(atm.distance).to eq(0.0)
      expect(atm.name).to eq("ATM")
      expect(atm.address).to eq("1701 Wynkoop St, Denver, CO 80202")
    end
  end
end
    