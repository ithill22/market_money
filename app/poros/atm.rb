class Atm
  attr_reader :id, :lat, :lon, :distance, :name, :address

  def initialize(atm_data)
    @lat = atm_data[:position][:lat]
    @lon = atm_data[:position][:lon]
    @distance = atm_data[:dist]
    @name = atm_data[:poi][:name]
    @address = atm_data[:address][:freeformAddress]
  end
end