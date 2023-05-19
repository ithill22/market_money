class AtmService

  def get_atms(lat, lon)
    get_url("/search/2/poiSearch/atm.json?lat=#{lat}&lon=#{lon}&radius=1000&limit=10")
  end

  private
  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def conn
    Faraday.new(url: 'https://api.tomtom.com') do |f|
      f.params['key'] = 'pLHmZIQCIER9z0l6XhhlGA20FY5xQIbu'
    end
  end
end