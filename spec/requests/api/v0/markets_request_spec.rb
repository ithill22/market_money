require 'rails_helper'

RSpec.describe 'Markets API' do
  before :each do
    create_list(:market, 3)
  end

  describe 'Send markets' do
    it 'sends a list of markets' do
      get '/api/v0/markets'

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json).to be_an Array
      expect(json.length).to eq(3)
    end
  end
end