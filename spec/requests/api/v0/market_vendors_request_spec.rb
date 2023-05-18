require 'rails_helper'

RSpec.describe 'Market Vendors API' do
  before :each do
    test_data
  end

  describe 'Create a new market vendor' do
    it 'creates a new market vendor' do
      market_vendor_params = {
        "market_id": @market_5.id,
        "vendor_id": @vendor_1.id
      }
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor_params)
      
      expect(response).to be_successful
      expect(response.status).to eq(201)
      
      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:message]).to eq("Market successfully added to vendor")
      data = json[:market_vendor][:data]
      expect(data).to be_a Hash
      expect(data).to have_key(:id)
      expect(data).to have_key(:type)
      expect(data).to have_key(:attributes)
      attributes = data[:attributes]
      expect(attributes).to be_a Hash
      expect(attributes[:market_id]).to eq(market_vendor_params[:market_id])
      expect(attributes[:vendor_id]).to eq(market_vendor_params[:vendor_id])
    end

    it 'returns 404 if market/vendor does not exist' do
      market_vendor_params = {
        "market_id": 100000,
        "vendor_id": @vendor_1.id
      }
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor_params)

      expect(response.status).to eq(404)

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json).to be_a Hash
      expect(json).to have_key(:errors)
      expect(json[:errors]).to be_an Array
      expect(json[:errors].count).to eq(1)

      error = json[:errors][0]
      expect(error).to be_a Hash
      expect(error).to have_key(:detail)
      expect(error[:detail]).to eq("Couldn't find Market with 'id'=#{market_vendor_params[:market_id]}")
      expect(error).to_not have_key(:source)
    end

    it 'returns 422 if market/vendor relationship already exists' do
      market_vendor_params = {
        "market_id": @market_1.id,
        "vendor_id": @vendor_1.id
      }
      headers = {"CONTENT_TYPE" => "application/json"}

      post "/api/v0/market_vendors", headers: headers, params: JSON.generate(market_vendor_params)

      expect(response.status).to eq(422)

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json).to be_a Hash
      expect(json).to have_key(:errors)
      expect(json[:errors]).to be_an Array
      expect(json[:errors].count).to eq(1)

      error = json[:errors][0]
      expect(error).to be_a Hash
      expect(error).to have_key(:detail)
      expect(error[:detail]).to eq("MarketVendor relationship already exists")
    end
  end
end