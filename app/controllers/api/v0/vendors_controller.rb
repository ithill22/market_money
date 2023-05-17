class Api::V0::VendorsController < ApplicationController
  def index
    market = Market.find_by(id: params[:market_id])
    if market
      render json: VendorSerializer.new(market.vendors)
    else
      render json: ErrorSerializer.serialize("Couldn't find Market with 'id'=#{params[:market_id]}"), status: 404
    end
  end

  def show
    vendor = Vendor.find_by(id: params[:id])
    if vendor
      render json: VendorSerializer.new(vendor)
    else
      render json: ErrorSerializer.serialize("Couldn't find Vendor with 'id'=#{params[:id]}"), status: 404
    end
  end

  def create
    vendor = Vendor.new(vendor_params)
    vendor.credit_accepted = false unless [true, false].include? params[:vendor][:credit_accepted]
    if vendor.save
      render json: VendorSerializer.new(vendor), status: 201
    else
      render json: ErrorSerializer.serialize("Information missing, could not create Vendor"), status: 400
    end
  end

  def destroy
    vendor = Vendor.find_by(id: params[:id])
    if vendor.nil?
      render json: ErrorSerializer.serialize("Couldn't find Vendor with 'id'=#{params[:id]}"), status: 404
    else
      vendor.destroy
    end
  end

  private
  def vendor_params
    params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
  end
end