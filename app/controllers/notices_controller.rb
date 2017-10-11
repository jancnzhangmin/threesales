class NoticesController < ApplicationController

  before_action :set_notice, only: [:show, :edit, :update, :destroy]

  def index
    @notices = Notice.all
  end

  def show
  end

  def edit
    @notices = Notice.all
  end

  def new
    @notice = Notice.new
  end

  def create
    @notice = Notice.new(notice_params)
    respond_to do |format|
      if @notice.save
        format.html { redirect_to notices_path, notice: 'Dgt was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @notice.update(notice_params)
        format.html { redirect_to notices_path, notice: 'Dgt was successfully updated.' }
        format.json { render :show, status: :ok, location: @notice }
      else
        format.html { render :edit }
        format.json { render json: @notice.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @notice.destroy
    respond_to do |format|
      format.html { redirect_to notices_path, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  private

# Use callbacks to share common setup or constraints between actions.
  def set_notice
    @notice = Notice.find(params[:id])
  end

  def notice_params
    params.require(:notice).permit(:noticeimg)
  end
end
