class OrdersController < ApplicationController
  before_action :authenticate_role
  def index
  end


  private
  def order_params
    params.require(:order).permit(:buycar_id, :product_id, :number, :price)
  end

end
