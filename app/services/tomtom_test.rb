require 'pry'
require 'faraday'
require 'json'
require 'figaro'

def conn
  Faraday.new(url: 'https://api.tomtom.com') do |f|
    f.params['key'] = ENV['TOMTOM_API_KEY']
  end
end


response = JSON.parse(conn.get("/search/2/poiSearch/atm.json?lat=39.7392&lon=-104.9903&radius=1000&limit=10").body, symbolize_names: true)
require 'pry'; binding.pry