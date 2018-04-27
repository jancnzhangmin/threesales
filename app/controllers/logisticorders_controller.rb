class LogisticordersController < ApplicationController
  before_action :authenticate_role
  before_action :set_logisticorder, only: [:show, :edit, :update, :destroy]


  def index
    @logisticorders = Logisticorder.all

  end
  def show

  end
  def edit
    @logistics = Logistic.all
  end

  def new
    @logisticorder = Logisticorder.new
    @logistics = Logistic.all
  end

  def create
    @logisticorder = Logisticorder.new(logisticorder_params)
    respond_to do |format|
      if @logisticorder.save
        format.html { redirect_to logisticorders_path, notice: 'Dgt was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @logisticorder.update(logisticorder_params)
        format.html { redirect_to logisticorders_path, notice: 'Dgt was successfully updated.' }
        format.json { render :show, status: :ok, location: @logisticorder }
      else
        format.html { render :edit }
        format.json { render json: @logisticorder.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @logisticorder.destroy
    respond_to do |format|
      format.html { redirect_to logisticorders_path, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  private

# Use callbacks to share common setup or constraints between actions.
  def set_logisticorder
    @logisticorder = Logisticorder.find(params[:id])
  end
# Never trust parameters from the scary internet, only allow the white list through.
  def logisticorder_params
    params.require(:logisticorder).permit(:logistic_id, :buycar_id,:ordernumber)
  end

end
