class StablesController < ApplicationController
  before_action :authenticate_role
  before_action :set_stable, only: [:show, :edit, :update, :destroy]
  def index
    @stables = Stable.all
  end

  def edit
  end

  def show
  end

  def new
    @stable = Stable.new
  end

  def create
    @stable = Stable.new(stable_params)
    respond_to do |format|
      if @stable.save
        format.html { redirect_to stables_url, notice: 'Retoforder was successfully created.' }
        format.json { render stables_url, status: :created, location: @stable }
      else
        format.html { render :new }
        format.json { render json: @stable.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @stable.update(stable_params)
        format.html { redirect_to stables_url, notice: 'Retoforder was successfully updated.' }
        format.json { render stables_url, status: :ok, location: @stable }
      else
        format.html { render :edit }
        format.json { render json: @stable.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @stable.destroy
    respond_to do |format|
      format.html { redirect_to stables_url, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_stable
    @stable = Stable.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def stable_params
    params.require(:stable).permit(:name, :lable, :stype)
  end
end
