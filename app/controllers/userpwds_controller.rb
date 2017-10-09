class UserpwdsController < ApplicationController

  before_action :set_userpwd, only: [:show, :edit, :update, :destroy]


  def index
    @userpwds = Userpwd.all

  end
  def show

  end
  def edit
  end

  def new
    @userpwd = Userpwd.new
  end

  def create
    @userpwd = Userpwd.new(user_params)
    respond_to do |format|
      if @userpwd.save
        format.html { redirect_to userpwds_path, notice: 'Dgt was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @userpwd.update(userpwd_params)
        format.html { redirect_to userpwd_path, notice: 'Dgt was successfully updated.' }
        format.json { render :show, status: :ok, location: @userpwd }
      else
        format.html { render :edit }
        format.json { render json: @userpwd.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @userpwd.destroy
    respond_to do |format|
      format.html { redirect_to userpwds_path, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  private

# Use callbacks to share common setup or constraints between actions.
  def set_userpwd
    @userpwd = Userpwd.find(params[:id])
  end
# Never trust parameters from the scary internet, only allow the white list through.
  def userpwd_params
    params.require(:userpwd).permit(:user_id, :password_digest)
  end

end
