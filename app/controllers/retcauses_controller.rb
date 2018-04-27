class RetcausesController < ApplicationController
  before_action :authenticate_role
  before_action :set_retcause, only: [:show, :edit, :update, :destroy]
  def index
    @retcauses = Retcause.all.order('num')
  end

  def edit

  end
  def show
  end

  def new
    @retcause = Retcause.new
  end

  def create
    @retcause = Retcause.new(retcause_params)
    respond_to do |format|
      if @retcause.save
        format.html { redirect_to retcauses_url, notice: 'Retoforder was successfully created.' }
        format.json { render retcauses_url, status: :created, location: @retcause }
      else
        format.html { render :new }
        format.json { render json: @retcause.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @retcause.update(retcause_params)
        format.html { redirect_to retcauses_url, notice: 'Retoforder was successfully updated.' }
        format.json { render retcauses_url, status: :ok, location: @retcause }
      else
        format.html { render :edit }
        format.json { render json: @retcause.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @retcause.destroy
    respond_to do |format|
      format.html { redirect_to retcauses_url, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_retcause
    @retcause = Retcause.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def retcause_params
    params.require(:retcause).permit(:num, :label)
  end
end
