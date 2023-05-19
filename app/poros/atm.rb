class Atm
  attr_reader :lat, :lon, :distance, :name, :address

  def initialize(data)
    @lat = data[:position][:lat]
    @lon = data[:position][:lon]
    @distance = data[:distance]
    @name = data[:poi][:name]
    @address = data[:address][:freeformAddress]
  end
end