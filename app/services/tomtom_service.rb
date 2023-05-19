class AtmService

  def get_atm(lat, lon)
    get_url("/search/2/poiSearch/atm.json?lat=#{lat}&lon=#{lon}&radius=1000&limit=10")
  end

  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def conn
    Faraday.new(url: 'https://api.tomtom.com') do |f|
      f.params['key'] = ENV['TOMTOM_API_KEY']
    end
  end
end