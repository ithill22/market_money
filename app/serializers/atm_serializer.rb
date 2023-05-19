class AtmSerializer
  include JSONAPI::Serializer
  attributes :lat, :lon, :distance, :name, :address
end