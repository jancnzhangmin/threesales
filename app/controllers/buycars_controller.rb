class BuycarsController < ApplicationController

  def index
    @seller = Seller.find(params[:seller_id])
    @buycars = @seller.buycars
  end


  private
  def buycar_params
    params.require(:buycar).permit(:selleruser_id, :amount, :status, :ordernumber)
  end
end
