class SellerusersController < ApplicationController
  before_action :authenticate_role
  private
  def selleruser_params
    params.require(:selleruser).permit(:seller_id, :user_id, :up_id, :openid, :qrcode, :qrcodetime)
  end
end
