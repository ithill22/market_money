require 'rails_helper'

RSpec.describe 'Vendors API' do
  before :each do
    test_data
  end

  describe 'Send all vendors' do
    it 'sends a list of all vendors for specified market' do
      get "/api/v0/markets/#{@market_1.id}/vendors"

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json).to be_a Hash
      expect(json).to have_key(:data)
      expect(json[:data]).to be_an Array
      expect(json[:data].count).to eq(5)

      json[:data].each do |vendor|
        expect(vendor).to have_key(:id)
        expect(vendor).to have_key(:type)
        expect(vendor).to have_key(:attributes)
        
        attributes = vendor[:attributes]
        expect(attributes).to be_a Hash
        expect(attributes).to have_key(:name)
        expect(attributes).to have_key(:description)
        expect(attributes).to have_key(:contact_name)
        expect(attributes).to have_key(:contact_phone)
        expect(attributes).to have_key(:credit_accepted)

        expect(attributes[:name]).to be_a String
        expect(attributes[:description]).to be_a String
        expect(attributes[:contact_name]).to be_a String
        expect(attributes[:contact_phone]).to be_a String
        expect(attributes[:credit_accepted]).to be_kind_of(TrueClass).or be_kind_of(FalseClass)
      end
    end

    it 'If the specified market does not exist, it returns a 404' do
      get "/api/v0/markets/#{1000000}/vendors"

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