class SellermodelsController < ApplicationController
  before_action :set_seller, only: [:index, :new, :create, :show, :edit, :update, :destroy]
  before_action :set_sellermodel, only: [:show, :edit, :update, :destroy]

  def index
    @sellermodels = @seller.sellermodels
    @wxjson = getwxmodel(@seller.id)
    zt = 0
    model = Array.new
    @sellermodels.each do |sm|
      zt = 0
      @wxjson.each do |wx|
        if sm.modeid ==  wx['template_id']
          zt = 1
          model.push(wx)
          sm.wxtype = 0
        end
      end
      if zt == 0
        #sm.destroy
        sm.wxtype = 1
      end
      sm.save
    end
    zt = Array.new
    @wxjson.each do |wx|
      zt.push(wx)
    end
    zt = zt - model
    if zt.length
      zt.each do |newmod|
        mod = @seller.sellermodels.new
        mod.modeid = newmod['template_id']
        mod.stype = 0
        mod.save
        str = newmod['content']
        str = str.split("\n")
        str.each do |con|
          if con != ''
            sta = con.index('{{') + 2
            ennum = con.index('.') - 1
            con = con[sta..ennum]
            modelcont = Modelcont.new
            modelcont.sellermodel_id = mod.id
            modelcont.wxname = con
            modelcont.stype = 0
            modelcont.save
          end
        end
      end
    end
    @sellermodels = @seller.sellermodels
    #modelout(1,2,'o5E2BwRcsWxBvS-vrrbd76blwjGE',2)
  end

  def edit
    @stable = Stable.all
    @wxjson = getwxmodel(@seller.id)
  end

  def new
    @stable = Stable.all
    @sellermodel = @seller.sellermodels.new
    @wxjson = getwxmodel(@seller.id)
  end

  def create
    @sellermodel = Stable.new(sellermodel_params)
    respond_to do |format|
      if @stable.save
        format.html { redirect_to seller_sellermodels_url, notice: 'Retoforder was successfully created.' }
        format.json { render seller_sellermodels_url, status: :created, location: @sellermodel }
      else
        format.html { render :new }
        format.json { render json: @sellermodel.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @sellermodel.update(sellermodel_params)
        modelcon = modelconts_params
        modelcon.each do |mod|
          con = Modelcont.find(mod)
          con.tbname = modelcon[mod]['tbname']
          con.content = modelcon[mod]['content']
          con.stype = modelcon[mod]['stype']
          con.save
        end
        format.html { redirect_to seller_sellermodels_url, notice: 'Retoforder was successfully updated.' }
        format.json { render seller_sellermodels_url, status: :ok, location: @sellermodel }
      else
        format.html { render :edit }
        format.json { render json: @sellermodel.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    delwxmodel(@seller.id,@sellermodel.modeid)
    @sellermodel.destroy
    respond_to do |format|
      format.html { redirect_to seller_sellermodels_url, notice: '删除成功' }
      format.json { head :no_content }
    end
  end

  private

  def getwxmodel(sellerid)
    token = getaccesstoken(sellerid)
    wxjson = gethtml('https://api.weixin.qq.com/cgi-bin/template/get_all_private_template?access_token=' + token)
    wxjson = JSON.parse(wxjson)
    if wxjson['template_list']
      wxjson = wxjson['template_list']
      wxjson = wxjson.to_a
      wxjson.delete_at(0)
      wxjson = JSON.parse(wxjson.to_json)
    else
      wxjson = Array.new
    end
    return wxjson
  end

  def delwxmodel(sellerid,modelid)
    token = getaccesstoken(sellerid)
    ret = posthtml('https://api.weixin.qq.com/cgi-bin/template/del_private_template?access_token=' + token,'{"template_id":"' + modelid + '"}')
    return ret
  end

  def set_seller
    @seller = Seller.find(params[:seller_id])
  end

  def set_sellermodel
    @sellermodel = Sellermodel.find(params[:id])
  end
  def modelconts_params
    params[:sellermodel][:modelcont]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def sellermodel_params
    params.require(:sellermodel).permit(:tablename, :stype, :seller_id, :modeid)
  end
end
