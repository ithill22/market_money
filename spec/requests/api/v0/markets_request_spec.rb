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

        data = JSON.parse(response.body, symbolize_names: true)[:data]

        expect(data).to be_a Hash
        expect(data).to have_key(:id)
        expect(data).to have_key(:type)
        expect(data).to have_key(:attributes)

        attributes = data[:attributes]
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

    describe 'Search for markets' do 
      it 'can search for markets using city, state and name parameters' do
        @market = Market.create!(name: "Test Market", street: "123 Test St", city: "Denver", county: "Test County", state: "Colorado", zip: "12345", lat: "123.456", lon: "123.456")
        search_params = {
          "city": "Denver",
          "state": "Colorado",
          "name": "Test Market"
        }
        get "/api/v0/markets/search",  params: search_params

        expect(response).to be_successful
        expect(response.status).to eq(200)
        
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json).to be_a Hash
        expect(json).to have_key(:data)

        data = json[:data]
        expect(data).to be_an Array
        expect(data.count).to eq(1)
        
        market = data[0]
        expect(market).to have_key(:id)
        expect(market).to have_key(:type)
        expect(market[:type]).to eq("market") 
        expect(market).to have_key(:attributes)

        attributes = market[:attributes]
        expect(attributes).to be_a Hash
        expect(attributes).to have_key(:name)
        expect(attributes[:name]).to eq(@market.name)
        expect(attributes).to have_key(:city)
        expect(attributes[:city]).to eq(@market.city)
        expect(attributes).to have_key(:state)
        expect(attributes[:state]).to eq(@market.state)
      end

      it 'returns 422 if city is present but state is not' do
        @market = Market.create!(name: "Test Market", street: "123 Test St", city: "Denver", county: "Test County", state: "Colorado", zip: "12345", lat: "123.456", lon: "123.456")
        search_params = {
          "city": "Denver",
          "name": "Test Market"
        }
        get "/api/v0/markets/search",  params: search_params

        expect(response.status).to eq(422)
        
        error = JSON.parse(response.body, symbolize_names: true)[:errors][0]

        expect(error).to be_a Hash
        expect(error).to have_key(:detail)
        expect(error[:detail]).to eq("Invalid search parameters")
      end

      it 'if there are no matching results it returns a 200 with a message' do
        search_params = {
          "city": "Denver",
          "state": "Colorado",
          "name": "Test Market"
        }
        get "/api/v0/markets/search",  params: search_params

        expect(response).to be_successful
        expect(response.status).to eq(200)
        
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json).to be_a Hash
        expect(json).to have_key(:message)
        expect(json[:message]).to eq("No markets found")
      end
    end

    describe 'Send nearest ATMs', :vcr do
      it 'sends the nearest ATMs to a market' do
        market = Market.create!(name: 'Union Station Farmers Market', street: '1701 Wynkoop St', city: 'Denver', county: 'Denver', state: 'CO', zip: '80202', lat: '39.752831', lon: '-104.998331')
        
        get "/api/v0/markets/#{market.id}/nearest_atms"
        
        expect(response).to be_successful
        expect(response.status).to eq(200)
        
        json = JSON.parse(response.body, symbolize_names: true)
        expect(json).to be_a Hash
        expect(json).to have_key(:data)
        
        data = json[:data]
        expect(data).to be_an Array
        expect(data.count).to eq(10)
      end

      it 'returns 404 if market does not exist' do
        get "/api/v0/markets/#{1000000}/nearest_atms"

        expect(response.status).to eq(404)
        
        error = JSON.parse(response.body, symbolize_names: true)[:errors][0]
        expect(error).to be_a Hash
        expect(error).to have_key(:detail)
        expect(error[:detail]).to eq("Couldn't find Market")
      end
    end
  end
end