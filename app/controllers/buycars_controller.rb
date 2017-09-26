class BuycarsController < ApplicationController

  def index
    @sellerusers = @seller.sellerusers
  end


  private
  def buycar_params
    params.require(:buycar).permit(:selleruser_id, :amount, :status, :ordernumber)
  end
end
