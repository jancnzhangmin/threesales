class ProductclasController < ApplicationController
  before_action :authenticate_role
  before_action :set_productcla, only: [:show, :edit, :update, :destroy]
  before_action :set_seller,only: [:index, :new, :create, :show, :edit, :update, :destroy]
  def index

    @productclas = @seller.productclas
  end

  def edit


  end

  def new
@productcla=Productcla.new
  end

  def create
    @productclas = @seller.productclas
    @productclas = @productclas.create(productcla_params)
    redirect_to seller_productclas_path
  end

  def update
    respond_to do |format|
      if @productcla.update(@productcla_params)
        format.html { redirect_to seller_productclas_path, notice: 'Unit was successfully updated.' }
        format.json { render :show, status: :ok, location: @productcla }
      else
        format.html { render :edit }
        format.json { render json: @productcla.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @productcla.destroy
    respond_to do |format|
      format.html { redirect_to seller_productclas_path, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_productcla
    @productcla = Productcla.find(params[:id])
  end

  def set_seller
    @seller = Seller.find(params[:seller_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def productcla_params
    params.require(:productcla).permit(:cla)
  end
end
