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

  describe 'Send one vendor' do
    it 'sends one vendor by id' do
      get "/api/v0/vendors/#{@vendor_1.id}"

      expect(response).to be_successful
      
      data = JSON.parse(response.body, symbolize_names: true)[:data]

      expect(data).to be_a Hash
      expect(data).to have_key(:id)
      expect(data).to have_key(:type)
      expect(data).to have_key(:attributes)

      attributes = data[:attributes]
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

    it 'If vendor does not exist, returns 404' do
      get "/api/v0/vendors/#{1000000}"

      expect(response.status).to eq(404)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json).to have_key(:errors)
      expect(json[:errors]).to be_an Array
      expect(json[:errors].count).to eq(1)

      error = json[:errors][0]
      expect(error).to be_a Hash
      expect(error).to have_key(:detail)
      expect(error[:detail]).to eq("Couldn't find Vendor with 'id'=1000000")
      expect(error).to_not have_key(:source)
    end
  end

  describe 'Create a vendor' do
    it 'can create a new vendor' do
      vendor_params = {
        "name": "Kael's Kale",
        "description": "Kale for sale",
        "contact_name": "Kael",
        "contact_phone": "1234567890",
        "credit_accepted": true
      }
      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)

      expect(response).to be_successful
      expect(response.status).to eq(201)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json).to be_a Hash
      expect(json).to have_key(:data)
      expect(json[:data]).to have_key(:id)
      expect(json[:data]).to have_key(:type)
      expect(json[:data]).to have_key(:attributes)

      attributes = json[:data][:attributes]
      expect(attributes).to be_a Hash
      expect(attributes[:name]).to eq(vendor_params[:name])
      expect(attributes[:description]).to eq(vendor_params[:description])
      expect(attributes[:contact_name]).to eq(vendor_params[:contact_name])
      expect(attributes[:contact_phone]).to eq(vendor_params[:contact_phone])
      expect(attributes[:credit_accepted]).to eq(vendor_params[:credit_accepted])
    end

    it 'If vendor is missing information, returns 400' do
      vendor_params = {
        "description": "Kale for sale",
        "contact_name": "Kael",
        "contact_phone": "1234567890",
        "credit_accepted": true
      }
      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)

      expect(response.status).to eq(400)
     
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json).to have_key(:errors)
      expect(json[:errors]).to be_an Array
      expect(json[:errors].count).to eq(1)
      
      error = json[:errors][0]
      expect(error).to be_a Hash
      expect(error).to have_key(:detail)
      expect(error[:detail]).to eq("Information missing, could not create Vendor")
      expect(error).to_not have_key(:source)
    end

    it 'If boolean response is filled in with something other than a boolean it will default to false' do
      vendor_params = {
        "name": "Kael's Kale",
        "description": "Kale for sale",
        "contact_name": "Kael",
        "contact_phone": "1234567890",
        "credit_accepted": "bob"
      }
      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor: vendor_params)
      expect(response.status).to eq(201)
      
      json = JSON.parse(response.body, symbolize_names: true)
      # require 'pry'; binding.pry

      expect(json[:data][:attributes][:credit_accepted]).to eq(false)

    end
  end
  describe 'Delete a vendor' do
    it 'can delete a vendor' do
      delete "/api/v0/vendors/#{@vendor_1.id}"

      expect(response).to be_successful
      expect(response.status).to eq(204)

      expect(Vendor.count).to eq(4)
    end

    it 'If vendor does not exist, returns 404' do
      delete "/api/v0/vendors/#{1000000}"

      expect(response.status).to eq(404)
      expect(Vendor.count).to eq(5)

      error = JSON.parse(response.body, symbolize_names: true)[:errors][0]
      expect(error[:detail]).to eq("Couldn't find Vendor with 'id'=1000000")  
    end
  end
end