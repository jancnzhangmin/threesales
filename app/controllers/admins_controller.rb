class AdminsController < ApplicationController
  before_action :authenticate_role
  before_action :set_admin, only: [:show, :edit, :update, :destroy]
  before_action :set_seller,only: [:index, :new, :create, :show, :edit, :update, :destroy]

  def index
    if params[:seller_id] != nil
      @admins = @seller.admins
    else
      @admins = Admin.where('seller_id is null')
    end
  end

  def edit
    @admin = Admin.find(params[:id])
  end

  def new
    if params[:seller_id] != nil
      @admin = @seller.admins.new
    else
      @admin = Admin.new
    end
  end


  def create
    user = Admin.where("login = ?",params[:admin][:login])
    if user.length > 0
      redirect_to new_seller_admin_path(@seller)
    else
      if params[:seller_id] != nil
        @admins = @seller.admins.new
      else
        @admins = Admin.new
      end
      @admins.username = params[:admin][:username]
      @admins.password = params[:admin][:password]
      @admins.login = params[:admin][:login]
      @admins.status = params[:admin][:status]
      @admins.auth = params[:admin][:auth]
      @admins.save
      if params[:seller_id] != nil
        redirect_to seller_admins_path(@seller)
      else
        redirect_to admins_path
      end
    end
  end

  def update
    respond_to do |format|
      if @admin.update(admin_params)
        if params[:seller_id] != nil
          format.html { redirect_to seller_admins_path, notice: 'Unit was successfully updated.' }
          format.json { render :show, status: :ok, location: @admin }
        else
          format.html { redirect_to admins_path, notice: 'Unit was successfully updated.' }
          format.json { render :show, status: :ok, location: @admin }
        end
      else
        format.html { render :edit }
        format.json { render json: @admin.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @admin.destroy
    respond_to do |format|
      if params[:seller_id] != nil
        format.html { redirect_to seller_admins_path, notice: '删除成功' }
        format.json { head :no_content }
      else
        format.html { redirect_to admins_path, notice: '删除失败' }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_admin
    @admin = Admin.find(params[:id])
  end


  def set_seller
    if params[:seller_id] != nil
      @seller = Seller.find(params[:seller_id])
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def admin_params
    params.require(:admin).permit(:seller_id, :username, :password, :login, :status,:auth, :nids, :errpwd)
  end

end
