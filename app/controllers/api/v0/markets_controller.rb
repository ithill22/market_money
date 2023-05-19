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

  def search
    if valid_params?
      markets = Market.market_search(params[:city], params[:state], params[:name])
      if markets.empty?
        render json: { message: "No markets found" }, status: 200
      else
        render json: MarketSerializer.new(markets)
      end
    else
      render json: ErrorSerializer.serialize("Invalid search parameters"), status: 422
    end
  end

  def nearest_atms
    market = Market.find_by(id: params[:id])
    if market
      atm_facade = AtmFacade.new(market)
      atms = atm_facade.atm_details
      render json: AtmSerializer.new(atms)
    else
      render json: ErrorSerializer.serialize("Couldn't find Market"), status: 404
    end
  end

  private
  def market_params
    params.require(:market).permit(:name, :street, :city, :county, :state, :zip, :lat, :lon)
  end

  def valid_params?
    return false if params[:city].present? && !params[:state].present?
    return false if !params[:state].present? && !params[:name].present?
    true
  end
end