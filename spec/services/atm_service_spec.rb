require 'rails_helper'

RSpec.describe AtmService, :vcr do
  describe 'class methods' do
    describe '::get_atms' do
      it 'returns a list of atms' do
        atms = AtmService.new.get_atms(39.752831, -104.998331)
        expect(atms).to be_a(Hash)
        expect(atms[:results]).to be_an(Array)
        expect(atms[:results].count).to eq(10)

        atm = atms[:results].first
        expect(atm).to have_key(:address)
        expect(atm[:address]).to have_key(:freeformAddress)
        expect(atm[:address][:freeformAddress]).to be_a(String)
        expect(atm).to have_key(:dist)
        expect(atm[:dist]).to be_a(Float)
        expect(atm).to have_key(:poi)
        expect(atm[:poi]).to have_key(:name)
        expect(atm[:poi][:name]).to be_a(String)
        expect(atm).to have_key(:position)
        expect(atm[:position]).to have_key(:lat)
        expect(atm[:position][:lat]).to be_a(Float)
        expect(atm[:position]).to have_key(:lon)
        expect(atm[:position][:lon]).to be_a(Float)
      end
    end
  end
end