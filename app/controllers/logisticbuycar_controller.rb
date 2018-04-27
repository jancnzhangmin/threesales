class LogisticbuycarController < ApplicationController
  #before_action :authenticate_role
  before_action :set_seller, only: [:index, :edit, :new]
  before_action :set_buycar, only: [:index, :edit, :new, :create]
  before_action :set_logisticorder, only: [:edit, :destroy]
  before_action :set_url, only: [:index, :edit, :new, :create, :update]
  def index
    @logisticorders=@buycar.logisticorders
  end

  def edit
    @logistics = Logistic.all
  end

  def new
    @logisticorder = Logisticorder.new
    @logistics = Logistic.all
  end

  def update
    drms = params[:id].to_i
    if drms > 0
      @logisticorder = Logisticorder.find(params[:id])
      @logisticorder.logistic_id=params[:logistic]
      @logisticorder.ordernumber=params[:ordernumber]
      @logisticorder.save
    else
      @logisticorder=Logisticorder.new
      @logisticorder.buycar_id=params[:buycar_id]
      @logisticorder.logistic_id=params[:logistic]
      @logisticorder.ordernumber=params[:ordernumber]
      @logisticorder.save
    end
    render json: params[:callback]+'({"buycar":200})',content_type: "application/javascript"
  end

  def destroy
    @logisticorder.destroy
    render json: params[:callback]+'({"buycar":200})',content_type: "application/javascript"
  end

  private

  def set_url
    ddr=request.path
    ddr=ddr.sub('index','')
    ddr=ddr.sub('new','')
    ddr=ddr.sub('edit','')
    ddr=ddr.sub('update','')
    @newurl=ddr +'new'
    @editurl=ddr +'edit'
    @indurl=ddr +'index'
    @upurl=ddr +'update'
  end
  def set_logisticorder
    @logisticorder = Logisticorder.find(params[:id])
  end
  def set_seller
    @seller = Seller.find(params[:seller_id])
  end
  def set_buycar
    @buycar = Buycar.find(params[:buycar_id])
  end
  def logisticorder_params
    params.require(:logisticorder).permit(:logistic_id, :buycar_id, :ordernumber)
  end
end
