class ApisController < ApplicationController

  def getseller
    seller = Seller.find(params[:sellerid])
    render json: params[:callback]+'({"seller":' + seller.to_json + '})',content_type: "application/javascript"
  end

end
