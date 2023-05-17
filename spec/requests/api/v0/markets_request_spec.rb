require 'rails_helper'

RSpec.describe 'Markets API' do
  before :each do
    test_data
  end

  describe 'Send all markets' do
    it 'sends a list of all markets' do
      get '/api/v0/markets'

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json).to be_a Hash
      expect(json).to have_key(:data)
      expect(json[:data]).to be_an Array
      expect(json[:data].count).to eq(5)

      json[:data].each do |market|
        expect(market).to have_key(:id)
        expect(market).to have_key(:type)
        expect(market).to have_key(:attributes)

        attributes = market[:attributes]
        expect(attributes).to be_a Hash
        expect(attributes).to have_key(:name)
        expect(attributes).to have_key(:street)
        expect(attributes).to have_key(:city)
        expect(attributes).to have_key(:county)
        expect(attributes).to have_key(:state)
        expect(attributes).to have_key(:zip)
        expect(attributes).to have_key(:lat)
        expect(attributes).to have_key(:lon)
        expect(attributes).to have_key(:vendor_count)
        
        expect(attributes[:name]).to be_a String
        expect(attributes[:street]).to be_a String
        expect(attributes[:city]).to be_a String
        expect(attributes[:county]).to be_a String
        expect(attributes[:state]).to be_a String
        expect(attributes[:zip]).to be_a String
        expect(attributes[:lat]).to be_a String
        expect(attributes[:lon]).to be_a String
        expect(attributes[:vendor_count]).to be_an Integer
      end
    end

    describe 'Send one market' do
      it 'sends one market by id' do
        get "/api/v0/markets/#{@market_1.id}"

        expect(response).to be_successful

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:data]).to be_a Hash
        expect(json[:data]).to have_key(:id)
        expect(json[:data]).to have_key(:type)
        expect(json[:data]).to have_key(:attributes)

        attributes = json[:data][:attributes]
        expect(attributes).to be_a Hash
        expect(attributes).to have_key(:name)
        expect(attributes).to have_key(:street)
        expect(attributes).to have_key(:city)
        expect(attributes).to have_key(:county)
        expect(attributes).to have_key(:state)
        expect(attributes).to have_key(:zip)
        expect(attributes).to have_key(:lat)
        expect(attributes).to have_key(:lon)
        expect(attributes).to have_key(:vendor_count)

        expect(attributes[:name]).to eq(@market_1.name)
        expect(attributes[:street]).to eq(@market_1.street)
        expect(attributes[:city]).to eq(@market_1.city)
        expect(attributes[:county]).to eq(@market_1.county)
        expect(attributes[:state]).to eq(@market_1.state)
        expect(attributes[:zip]).to eq(@market_1.zip)
        expect(attributes[:lat]).to eq(@market_1.lat)
        expect(attributes[:lon]).to eq(@market_1.lon)
        expect(attributes[:vendor_count]).to eq(@market_1.vendor_count)
      end

      it 'If market does not exist, returns 404' do
        get "/api/v0/markets/#{1000000}"

        expect(response.status).to eq(404)

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json).to have_key(:errors)
        expect(json[:errors]).to be_an Array
        expect(json[:errors].count).to eq(1)

        error = json[:errors][0]
        expect(error).to be_a Hash
        expect(error).to have_key(:detail)
        expect(error[:detail]).to eq("Couldn't find Market with 'id'=1000000")
        expect(error).to_not have_key(:source)
      end
    end
  end
end