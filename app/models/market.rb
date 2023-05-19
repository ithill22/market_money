class Market < ApplicationRecord
  has_many :market_vendors
  has_many :vendors, through: :market_vendors

  validates_presence_of :name, :street, :city, :county, :state, :zip, :lat, :lon

  def vendor_count
    vendors.count
  end

  def self.market_search(city, state, name)
    where("city ILIKE ? AND state ILIKE ? AND name ILIKE ?", "%#{city}%", "%#{state}%", "%#{name}%")
  end
end