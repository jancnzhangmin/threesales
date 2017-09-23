class AdminsController < ApplicationController

  before_action :set_admin, only: [:show, :edit, :update, :destroy, :productcla]
  before_action :set_seller,only: [:index, :new, :create, :show, :edit, :update, :destroy]

  def index
    @admins = @seller.admins
  end

  def edit
    @admin = Admin.find(params[:id])

  end

  def new
    @admin = Admin.new
  end


  def create
    @admins = @seller.admins
    @admins = @admins.create(admin_params)
    redirect_to seller_admins_path
  end

  def update
    @admins = @seller.admins
    @admins = @admins.create(admin_params)
    redirect_to seller_admins_path
  end

  def destroy
    @admin.destroy
    respond_to do |format|
      format.html { redirect_to admins_path, notice: '删除成功' }
      format.json { head :no_content }
    end
  end



  private
  # Use callbacks to share common setup or constraints between actions.
  def set_admin
    @admin = Admin.find(params[:id])
  end


  def set_seller
    @seller = Seller.find(params[:seller_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def admin_params
    params.require(:admin).permit(:seller_id, :username, :password_digest, :login, :status,:auth)
  end

end
