class Api::V0::VendorsController < ApplicationController
  def index
    market = Market.find_by(id: params[:market_id])
    if market
      render json: VendorSerializer.new(market.vendors)
    else
      render json: ErrorSerializer.serialize("Couldn't find Market with 'id'=#{params[:market_id]}"), status: 404
    end
  end
end