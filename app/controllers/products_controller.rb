class ProductsController < ApplicationController
  before_action :authenticate_role
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :set_seller,only: [:index, :new, :create, :show, :edit, :update, :destroy]
  def index
    @productclas = @seller.productclas
    num = @seller.products.length
    if num != 0
      @pagenum = num / 20
      if ( num % 20 ) > 0
        @pagenum = @pagenum + 1
      end
    else
      @pagenum = 1
    end
    if (params[:page] == nil) || (params[:page].to_i <= 0)
      num = 0
    elsif params[:page].to_i >= @pagenum
      num = @pagenum - 1
      params[:page] = @pagenum
    else
      num = params[:page].to_i - 1
    end
    @products = @seller.products.order("id desc").limit((num * 20).to_s + ",20")
  end

  def edit
    @productclas = @seller.productclas
  end
  def show

  end

  def new
    @product = Product.new
    @productclas = @seller.productclas
  end

  def create
    @products = @seller.products
    @products = @products.create(product_params)
    if @products.bpnum == nil
      @products.bpnum = 0
      @product.sbpnum = 0
      @product.price = sprintf("%.2f",@product.price)
      @product.secondprice = sprintf("%.2f",@product.secondprice)
      @product.first = sprintf("%.2f",@product.first)
      @product.second = sprintf("%.2f",@product.second)
      @product.third = sprintf("%.2f",@product.third)
      @product.sfirst = sprintf("%.2f",@product.sfirst)
      @product.ssecond = sprintf("%.2f",@product.ssecond)
      @product.sthird = sprintf("%.2f",@product.sthird)
      @products.save
    end
    redirect_to seller_products_path
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        if @product.bpnum == nil
          @product.bpnum = 0
          @product.sbpnum = 0
          @product.price = sprintf("%.2f",@product.price)
          @product.secondprice = sprintf("%.2f",@product.secondprice)
          @product.first = sprintf("%.2f",@product.first)
          @product.second = sprintf("%.2f",@product.second)
          @product.third = sprintf("%.2f",@product.third)
          @product.sfirst = sprintf("%.2f",@product.sfirst)
          @product.ssecond = sprintf("%.2f",@product.ssecond)
          @product.sthird = sprintf("%.2f",@product.sthird)
          @product.save
        end
        format.html { redirect_to seller_products_path, notice: 'Unit was successfully updated.' }
        format.json { render :show, status: :ok, location: @seller }
      else
        format.html { render :edit }
        format.json { render json: @seller.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to seller_products_path, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  def set_seller
    @seller = Seller.find(params[:seller_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def product_params
    params.require(:product).permit(:productcla_id,:name,:spec,:model,:price,:content,:status,:secondprice,:seller_id,:productimg, :product_id, :first, :second, :third, :sfirst, :ssecond, :sthird, :bpnum, :sbpnum)
  end
end
