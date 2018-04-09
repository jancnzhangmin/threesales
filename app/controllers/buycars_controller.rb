class BuycarsController < ApplicationController
  before_action :set_buycar, only: [:edit, :update, :destroy]
  before_action :set_seller, only: [:edit, :update, :destroy]

  def index
    @seller = Seller.find(params[:seller_id])
    @buycars = @seller.buycars.where("deltype is null or deltype = 4").order('created_at desc')
  end

  def edit
    retoforder = Retoforder.where("buycar_id = ?",@buycar.id)
    if retoforder.length > 0
      @retoforder = retoforder[0]
      @retcause = Retcause.where("num = ?",@retoforder.retreason)
      if @retcause.length > 0
        @retcause = @retcause[0]
      else
        @retcause = nil
      end
    end
    @receives = Receive.where("buycar_id = ?",@buycar.id)
    @receives = @receives[0]
    @logisticorders = Logisticorder.where("buycar_id = ?",@buycar.id)
  end

  def editstatus
    @buycar = Buycar.find(params[:id])
    logisti = Logisticorder.where("buycar_id = ?",@buycar.id)
    if logisti.length > 0
      @buycar.status=2
      @buycar.save
      render json: params[:callback]+'({"buycar":200})',content_type: "application/javascript"
    end

  end

  def update
    respond_to do |format|
      if @buycar.update(buycar_params)
        format.html { redirect_to seller_buycars_path, notice: 'Unit was successfully updated.' }
        format.json { render :show, status: :ok, location: @seller }
      else
        format.html { render :edit }
        format.json { render json: @seller.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    #order=@buycar.orders
    #order.each { |ord| ord.destroy }
    if @buycar.status != nil
      thirdownid(3,@buycar.selleruser_id,@buycar.id)
    end
    #@buycar.destroy
    if @buycar.deltype == 4
      @buycar.deltype = 6
    else
      @buycar.deltype = 2
    end
    @buycar.save
    respond_to do |format|
      format.html { redirect_to seller_buycars_path, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  def setsellererr
    ddr = params.require(:retoforder).permit(:id,:sellertext)
    retof = Retoforder.find(ddr['id'])
    retof.sellertext = ddr['sellertext']
    @buycar = Buycar.find(params[:id])
    @seller = Seller.find(params[:seller_id])
    retof.rettype = 33
    @buycar.status = 30
    @buycar.save
    retof.save
    redirect_to [:edit,@seller,@buycar]
  end

  private

  def thirdownid(num,id,buyid)
    if(num>0 && id)
      buycar = Buycar.find(buyid)
      selluser = Selleruser.find(id)
      user = User.find(selluser.user_id)
      if(num == 1)
        user.undthird = user.undthird - buycar.first
      elsif (num == 2)
        user.undsenond = user.undsenond - buycar.second
      elsif (num == 3)
        user.undfirst = user.undfirst - buycar.third
      end
      num = num - 1
      user.save
      if num > 1
        thirdownid(num,selluser.up_id,buyid)
      end
    end
  end

  def set_buycar
    @buycar = Buycar.find(params[:id])
  end

  def set_seller
    @seller = Seller.find(params[:seller_id])
  end

  def buycar_params
    params.require(:buycar).permit(:selleruser_id, :amount, :status, :ordernumber,:seller_id,:user_id,:remark)
  end
end
