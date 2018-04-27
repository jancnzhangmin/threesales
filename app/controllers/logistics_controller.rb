class LogisticsController < ApplicationController
  before_action :authenticate_role
  before_action :set_logistic, only: [:show, :edit, :update, :destroy]

  def index
    @logistics = Logistic.all
  end

  def edit
  end

  def show
  end

  def new
    @logistic = Logistic.new
  end

  def create
    @logistic = Logistic.new(logistic_params)
    respond_to do |format|
      if @logistic.save
        format.html { redirect_to logistics_path, notice: 'Dgt was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end
  def update
    respond_to do |format|
      if @logistic.update(logistic_params)
        format.html { redirect_to logistics_path, notice: 'Dgt was successfully updated.' }
        format.json { render :show, status: :ok, location: @logistic }
      else
        format.html { render :edit }
        format.json { render json: @logistic.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @logistic.destroy
    respond_to do |format|
      format.html { redirect_to logistics_path, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  private
# Use callbacks to share common setup or constraints between actions.
  def set_logistic
    @logistic = Logistic.find(params[:id])
  end
# Never trust parameters from the scary internet, only allow the white list through.
  def logistic_params
    params.require(:logistic).permit(:logistic)
  end

end
