class AtmFacade
  def initialize(market)
    @lat = market.lat.to_f
    @lon = market.lon.to_f
  end

  def atm_details
    service.get_atms(@lat, @lon)[:results].map do |atm_data|
      Atm.new(atm_data)
    end
  end

  private
  def service
    _service ||= AtmService.new
  end
end