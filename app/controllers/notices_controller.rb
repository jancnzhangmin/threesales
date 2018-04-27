class NoticesController < ApplicationController
  before_action :authenticate_role
  before_action :set_notice, only: [:show, :edit, :update, :destroy]
  before_action :set_seller, only: [:index, :show, :new, :edit, :update, :destroy]

  def index
    if @seller
      @notices = @seller.notices
    else
      @notices = Notice.where('seller_id is null')
    end

  end

  def show
  end

  def edit
    @notices = Notice.all
  end

  def new
    @notice = Notice.new
    if @seller
      @notice.seller_id=@seller.id
    end
  end

  def create

    @notice = Notice.new(notice_params)
    if notice_params[:recommend]
      @notice.recommend = notice_params[:recommend]
    else
      @notice.status = notice_params[:status]
      @seller = Seller.find(@notice.seller_id)
    end
    respond_to do |format|
      if @notice.save
        if notice_params[:seller_id]
          format.html { redirect_to seller_notices_path(@seller), notice: 'Dgt was successfully created.' }
          format.json { render :show, status: :ok, location: @seller }
        else
          format.html { redirect_to notices_path, notice: 'Dgt was successfully created.' }
        end

      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @notice.update(notice_params)
        if @notice.seller_id
          @seller = Seller.find(@notice.seller_id)
          format.html { redirect_to seller_notices_path(@seller), notice: 'Dgt was successfully updated.' }
        else
          format.html { redirect_to notices_path, notice: 'Dgt was successfully updated.' }
        end
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
      if @notice.seller_id
        @seller = Seller.find(@notice.seller_id)
        format.html { redirect_to seller_notices_path(@seller), notice: '删除成功' }
      else
        format.html { redirect_to notices_path, notice: '删除成功' }
      end
      format.json { head :no_content }
    end
  end

  private

# Use callbacks to share common setup or constraints between actions.
  def set_notice
    @notice = Notice.find(params[:id])
  end

  def set_seller
    if params[:seller_id]
      @seller = Seller.find(params[:seller_id])
    end
  end

  def notice_params
    params.require(:notice).permit(:noticeimg, :recommend, :status, :seller_id)
  end
end
