class RetofordersController < ApplicationController
  before_action :set_retoforder, only: [:show, :edit, :update, :destroy, :setretok, :setretno, :setlogisticok]
  before_action :set_seller, only: [:setretok, :setretno, :update, :setlogisticok]
  before_action :set_buycar, only: [:setretok, :setretno, :update, :setlogisticok]
  # GET /retoforders
  def index
    @retoforders = Retoforder.all
  end

  # GET /retoforders/1
  def show
  end

  # GET /retoforders/new
  def new
    @retoforder = Retoforder.new
  end

  # GET /retoforders/1/edit
  def edit
  end

  def setretok        #退钱
    if @retoforder.rettype == 2
      @retoforder.rettype = 3
      @buycar.status = 30
      @buycar.save
      @retoforder.save
    elsif @retoforder.rettype == 13
      @retoforder.rettype = 13
      @retoforder.save
    end
    redirect_to [:edit,@seller,@buycar]
  end

  def setretno
    if @retoforder.rettype == 2
      @retoforder.rettype = 31
      @buycar.status = 30
      @buycar.save
      @retoforder.save
    elsif @retoforder.rettype == 11
      @retoforder.rettype = 32
      @buycar.status = 30
      @buycar.save
      @retoforder.save
    elsif @retoforder.rettype == 13
      @retoforder.rettype = 33
      @buycar.status = 30
      @buycar.save
      @retoforder.save
    end
    redirect_to [:edit,@seller,@buycar]
  end

  def setlogisticok
    if @retoforder.rettype == 13
      @retoforder.rettype = 14
      @buycar.status = 30
      @buycar.save
      @retoforder.save
    end
    redirect_to [:edit,@seller,@buycar]
  end

  # POST /retoforders
  def create
    @retoforder = Retoforder.new(retoforder_params)

    respond_to do |format|
      if @retoforder.save
        format.html { redirect_to @retoforder, notice: 'Retoforder was successfully created.' }
        format.json { render :show, status: :created, location: @retoforder }
      else
        format.html { render :new }
        format.json { render json: @retoforder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /retoforders/1
  def update
    respond_to do |format|
      if @retoforder.update(retoforder_params)
        @retoforder.rettype = 12
        @retoforder.save
        format.html { redirect_to [:edit,@seller,@buycar], notice: 'Retoforder was successfully updated.' }
        format.json { render :show, status: :ok, location: @retoforder }
      else
        format.html { render :edit }
        format.json { render json: @retoforder.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /retoforders/1
  def destroy
    @retoforder.destroy
    respond_to do |format|
      format.html { redirect_to retoforders_url, notice: 'Retoforder was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_retoforder
      @retoforder = Retoforder.find(params[:id])
    end

    def set_seller
      @seller = Seller.find(params[:seller_id])
    end

    def set_buycar
      @buycar = Buycar.find(params[:buycar_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def retoforder_params
      params.require(:retoforder).permit(:selleruser_id, :rettype, :ordertype, :other, :retreason, :retcomment, :retmoney, :name, :tel, :region, :address, :logisticname, :logisticnum, :sellertext, :buycar_id)
    end

end
