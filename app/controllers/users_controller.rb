class UsersController < ApplicationController
  before_action :authenticate_role
  before_action :set_user, only: [:show, :edit, :update, :destroy]


  def index
    @users = User.all

  end
  def show

  end
  def edit
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: 'Dgt was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_path, notice: 'Dgt was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_path, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  private

# Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end
# Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:login, :password_digest,:vcode,:vcodetime)
  end
end
