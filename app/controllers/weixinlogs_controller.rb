class WeixinlogsController < ApplicationController
  before_action :authenticate_role
  before_action :set_weixinlog, only: [:edit, :update, :destroy]
  def index
    num = Weixinlog.all.length
    if num != 0
      @pagenum = num / 20
      if ( num % 20 ) > 0
        @pagenum = @pagenum + 1
      end
    else
      @pagenum = 1
    end
    if (params[:page] == nil) || (params[:page].to_i <= 0)
      num = 0
    elsif params[:page].to_i >= @pagenum
      num = @pagenum - 1
      params[:page] = @pagenum
    else
      num = params[:page].to_i - 1
    end

    @weixinlog=Weixinlog.all.order('id desc').limit((num * 20).to_s + ",20")

  end
  def edit

  end
  def new
    @weixinlog=Weixinlog.new
  end
  def create
    @weixinlog = Weixinlog.new(weixinlog_params)
    respond_to do |format|
      if @weixinlog.save
          format.html { redirect_to weixinlogs_path, notice: 'Dgt was successfully created.' }
          format.json { render :index, status: :ok }
      else
        format.html { render :new }
      end
    end
  end
  def update
    respond_to do |format|
      if @weixinlog.update(weixinlog_params)
        format.html { redirect_to weixinlogs_path, notice: 'Unit was successfully updated.' }
        format.json { render :index, status: :ok }
      else
        format.html { render :edit }
        format.json { render json: @weixinlog.errors, status: :unprocessable_entity }
      end
    end
  end
  def destroy
    @weixinlog.destroy
    respond_to do |format|
      format.html { redirect_to weixinlogs_path, notice: '删除成功' }
      format.json { head :no_content }
    end
  end
  private
  def set_weixinlog
    @weixinlog = Weixinlog.find(params[:id])
  end
  def weixinlog_params
    params.require(:weixinlog).permit(:log, :url)
  end
end
