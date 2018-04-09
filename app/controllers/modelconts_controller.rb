class ModelcontsController < ApplicationController
  before_action :set_seller, only: [:index, :new, :create, :show, :edit, :update, :destroy]
  before_action :set_sellermodel, only: [:index, :new, :create, :show, :edit, :update, :destroy]
  before_action :set_modelcont, only: [:show, :edit, :update, :destroy]
  def index
    @modelconts=@sellermodel.modelconts
  end
  private
  def set_seller
    @seller = Seller.find(params[:seller_id])
  end

  def set_sellermodel
    @sellermodel = Sellermodel.find(params[:sellermodel_id])
  end

  def set_modelcont
    @modelcont = Modelcont.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def modelcont_params
    params.require(:modelcont).permit(:tbname, :wxname, :content, :stype, :sellermodel_id)
  end
end
