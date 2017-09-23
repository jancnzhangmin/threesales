class SellersController < ApplicationController

  before_action :set_seller, only: [:show, :edit, :update, :destroy, :productcla]
  def index
    @sellers = Seller.all
  end

  def edit
    @seller = Seller.find(params[:id])

  end

  def new
    @seller = Seller.new
  end


  def create
    @seller = Seller.new(seller_params)

    respond_to do |format|
      if @seller.save
        format.html { redirect_to sellers_path, notice: 'Unit was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @seller.update(seller_params)
        format.html { redirect_to sellers_path, notice: 'Unit was successfully updated.' }
        format.json { render :show, status: :ok, location: @seller }
      else
        format.html { render :edit }
        format.json { render json: @seller.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @seller.destroy
    respond_to do |format|
      format.html { redirect_to sellers_path, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

def show
  @productclacount = @seller.productclas.count
end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_seller
    @seller = Seller.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def seller_params
    params.require(:seller).permit(:name, :summary, :tel, :address, :status, :shortname, :sellerimage)
  end

end
