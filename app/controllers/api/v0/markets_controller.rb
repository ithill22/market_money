class Api::V0::MarketsController < ApplicationController
  def index
    render json: MarketSerializer.new(Market.all)
  end

  def show
    market = Market.find_by(id: params[:id])
    if market
      render json: MarketSerializer.new(market)
    else
      render json: ErrorSerializer.serialize("Couldn't find Market with 'id'=#{params[:id]}"), status: 404
    end
  end
end