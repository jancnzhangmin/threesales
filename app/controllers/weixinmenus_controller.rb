class WeixinmenusController < ApplicationController
  before_action :authenticate_role
  before_action :set_seller, only: [:index]
  def index
    name=Weixinmenu.where("sitrue = 0 and seller_id = ?",@seller.id)
    name.each do |na|
      na.destroy
    end
    @weixinmenuhome=Weixinmenu.where("seller_id = ? and up_id is null",@seller.id).order("number")
    @weixinmenusub=Weixinmenu.where("seller_id = ? and up_id is not null",@seller.id).order("number")
  end
  def saveweixin
    if params[:id]
      weixin=Weixinmenu.find(params[:id])
    else
      if params[:upid]
        weixin=Weixinmenu.where("seller_id = ? and up_id = ? and number = ?",params[:sid],params[:upid],params[:number])
      else
        weixin=Weixinmenu.where("seller_id = ? and up_id is null and number = ?",params[:sid],params[:number])
      end

      if weixin.length > 0
        weixin=weixin[0]
      else
        weixin=Weixinmenu.new
      end
    end
    if weixin.seller_id
      if weixin.seller_id == params[:sid].to_i
        weixin.seller_id=params[:sid]
        weixin.number=params[:number]
        weixin.name=params[:name]
        weixin.url=params[:url]
        weixin.gettype=params[:type]
        weixin.up_id=params[:upid]
        weixin.sitrue=1
        weixin.save
        render json: params[:callback]+'({"weixinmenu":"'+weixin.id.to_s+'"})',content_type: "application/javascript"
      else
        render json: '({"err":"0"})',content_type: "application/javascript"
      end
    else
      weixin.seller_id=params[:sid]
      weixin.number=params[:number]
      weixin.name=params[:name]
      weixin.url=params[:url]
      weixin.gettype=params[:type]
      weixin.up_id=params[:upid]
      weixin.sitrue=1
      weixin.save
      render json: params[:callback]+'({"weixinmenu":"'+weixin.id.to_s+'"})',content_type: "application/javascript"
    end
  end
  def saveid
    weixin=Weixinmenu.where("seller_id = ? and number = ? and up_id is null",params[:sellerid],params[:number])
    if(weixin.length > 0)
      weixin=weixin[0]
      render json: params[:callback]+'({"weixinmenu":"'+weixin.id.to_s+'"})',content_type: "application/javascript"
    else
      weixin=Weixinmenu.new
      weixin.seller_id=params[:sellerid]
      weixin.number=params[:number]
      weixin.name='新建按钮'
      weixin.sitrue=0
      weixin.save
      render json: params[:callback]+'({"weixinmenu":"'+weixin.id.to_s+'"})',content_type: "application/javascript"
    end
  end

  def delid
    ids=params[:id].split(',')
    ids.each do |na|
      if(na.to_i > 0)
        weixin=Weixinmenu.find(na)
        if weixin.up_id == nil
          weixindel = Weixinmenu.where("up_id = ?",weixin.id)
          if weixindel.length > 0
            weixindel.each do |uar|
              uar.destroy
            end
          end
        end
        weixin.destroy
      end
    end
    render json: params[:callback]+'({"err":"0"})',content_type: "application/javascript"
  end

  def loading
    err = delmenu(params[:id])
    button='{"button":['
    weixinmenuhome=Weixinmenu.where("seller_id = ? and up_id is null",params[:id]).order("number")
    weixinmenusub=Weixinmenu.where("seller_id = ? and up_id is not null",params[:id]).order("number")
    weixinmenuhome.each do |menu|
      _ordate='['
      weixinmenusub.each do |sub|
        if(sub.up_id == menu.id)
          _ordate = _ordate + '{"type":"'+gettype(sub.gettype)+'","name":"'+sub.name+'","url":"' + geturl(sub.gettype,sub.url,sub.seller_id) + '"},'
        end
      end
      _ordate=_ordate.chop+']'
      if(_ordate == ']')
        button = button + '{"type":"'+gettype(menu.gettype)+'","name":"'+menu.name+'","url":"' + geturl(menu.gettype,menu.url,menu.seller_id) +'"},'
      else
        button = button + '{"name": "'+ menu.name + '", "sub_button":' + _ordate + '},'
      end
    end
    button = button.chop + ']}'
    err = createmenu(params[:id],button)
    render json: params[:callback]+'({"err":' + err + '})',content_type: "application/javascript"
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_seller
    @seller = Seller.find(params[:seller_id])
  end

  def set_weixinmenu
    @weixinmenu = Weixinmenu.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def weixinmenu_params
    params.require(:weixinmenu).permit(:name, :gettype, :url, :key, :media_id, :seller_id, :up_id, :number)
  end

end
