class ReceivesController < ApplicationController
  before_action :authenticate_role

  private
  def receive_params
    params.require(:receive).permit(:buycar_id, :name, :tel, :region, :address)
  end
end
