class AtmFacade
  def initialize(market)
    @lat = market.lat.to_f
    @lon = market.lon.to_f
  end

  def atm_details
    Atm.new(atm_service.get_atm(@lat, @lon))
  end
end