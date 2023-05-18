class Api::V0::MarketVendorsController < ApplicationController
  def create
    market = Market.find_by(id: params[:market_id])
    vendor = Vendor.find_by(id: params[:vendor_id]) 
    if market && vendor
      market_vendor = MarketVendor.find_by(market: market, vendor: vendor)
      if market_vendor
        render json: ErrorSerializer.serialize("MarketVendor relationship already exists"), status: 422
      else
        market_vendor = MarketVendor.new(market: market, vendor: vendor)
        market_vendor.save
        render json: {
          message: "Market successfully added to vendor",
          market_vendor: MarketVendorSerializer.new(market_vendor)
        }, status: 201
      end
    else
      render json: ErrorSerializer.serialize("Couldn't find Market with 'id'=#{params[:market_id]}"), status: 404
    end
  end  

  def destroy
    market_vendor = MarketVendor.find_by(market_id: params[:market_id], vendor_id: params[:vendor_id])
    if market_vendor
      market_vendor.destroy
    else
      render json: ErrorSerializer.serialize("Couldn't find MarketVendor with 'id'=#{params[:id]}"), status: 404
    end
  end
end

  