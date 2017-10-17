class RecepitaddresController < ApplicationController

  before_action :set_recepitaddre, only: [:show, :edit, :update, :destroy]

  def index
    @recepitaddres = Recepitaddre.all
  end

  def show
  end

  def edit
  end

  def new
    @recepitaddre = Recepitaddre.new
  end

  def create
    @recepitaddre = Recepitaddre.new(recepitaddre_params)

    respond_to do |format|
      if @recepitaddre.save
        format.html { redirect_to recepitaddres_path, notice: 'Unit was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @recepitaddre.update(recepitaddre_params)
        format.html { redirect_to recepitaddres_path, notice: 'Dgt was successfully updated.' }
        format.json { render :show, status: :ok, location: @recepitaddre }
      else
        format.html { render :edit }
        format.json { render json: @recepitaddre.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @recepitaddre.destroy
    respond_to do |format|
      format.html { redirect_to recepitaddres_path, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  private
# Use callbacks to share common setup or constraints between actions.
  def set_recepitaddre
    @recepitaddre = Recepitaddre.find(params[:id])
  end
# Never trust parameters from the scary internet, only allow the white list through.
  def recepitaddre_params
    params.require(:recepitaddre).permit(:user_id, :name, :tel, :region, :address, :choice)
  end


end
