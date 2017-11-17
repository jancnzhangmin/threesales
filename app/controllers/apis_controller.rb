class ApisController < ApplicationController
  require "rexml/document"
  include REXML
  before_action :set_openid, only: [:getnotice, :getbuycarlist, :getproductlist, :getrecepit, :getreceoitadd, :getrecepitone, :getreceoitedit, :getreceoitdel, :getreceoitdefault]
  skip_before_action :verify_authenticity_token, :only => [:weixingetpost]
  def set_openid
    if params[:openid]
      seller=Selleruser.where(" openid = ? ",params[:openid])
      @userid=User.where('id = ?',seller[0].user_id)
      @sellerid=Seller.where('id = ?',seller[0].seller_id)
    else
      if params[:id]
        @userid=User.where('id = ?',params[:id])
      else
        render json: params[:callback]+'({"user":' + '0' + '})',content_type: "application/javascript"
      end
    end
  end
  class Noticecla
    attr :id,true
    attr :img,true
  end
  def getnotice
    if params[:openid]
      notice = Notice.where('seller_id = ? and status = 1',@sellerid[0].id).order('updated_at desc').limit(5)
    else
      notice = Notice.where('recommend = 1').order('updated_at desc').limit(5)
    end
    noticeall = Array.new
    notice.each do |pro|
      nclass = Noticecla.new
      nclass.id = pro.id
      nclass.img = pro.noticeimg.url
      noticeall.push(nclass)
    end
    render json: params[:callback]+'({"notice":' + noticeall.to_json + '})',content_type: "application/javascript"
  end

  def getseller
    seller = Seller.find(params[:sellerid])
    render json: params[:callback]+'({"seller":' + seller.to_json + '})',content_type: "application/javascript"
  end

  class Prolist
    attr :id,true
    attr :productimg,true
  end
  def getproductlist
    productls=Product.where('status = 1')
    if params[:openid]
      productls=Product.where('seller_id = ? and status = 1',@sellerid[0].id)
    end
    productarr = Array.new
    productls.each do |pro|
      pclass = Prolist.new
      pclass.id = pro.id
      pclass.productimg = pro.productimg.url
      productarr.push(pclass)
    end
    render json: params[:callback]+'({"products":'+productarr.to_json+'})',content_type: "application/javascript"
  end
  class Pronameclass
    attr :id,true
    attr :productimg,true
    attr :name,true
    attr :money,true
  end

  def getproname
    productls=Product.find(params[:id])
    productarr = Array.new

    pclass = Pronameclass.new
    pclass.id = productls.id
    pclass.productimg = productls.productimg.url
    pclass.name = productls.name
    pclass.money = productls.price
    productarr.push(pclass)

    render json: params[:callback]+'({"products":'+productarr.to_json+'})',content_type: "application/javascript"
  end
  class Proname
    attr :id,true
    attr :name,true
    attr :content,true
  end

  def getproductcontent
    debugger
    productnas=Product.find(params[:id])
    productarr = Array.new
    ser=Seller.find(productnas.seller_id)
    pcont= Proname.new
    pcont.id = productnas.id
    pcont.name = ser.name
    pcont.content = productnas.content
    productarr.push(pcont)

    render json: params[:callback]+'({"products":'+ productarr.to_json + '})',content_type: "application/javascript"
  end
  class Adder
    attr :id, true
    attr :name, true
    attr :tel, true
    attr :region, true
    attr :address, true
    attr :choice, true
  end

  def getrecepit
    recepit = Recepitaddre.where('user_id = ?',@userid[0].id)
    addrarr = Array.new
    recepit.each do |rec|
      add = Adder.new
      add.id = rec.id
      add.name = rec.name
      add.tel = rec.tel
      add.region = rec.region
      add.address = rec.address
      add.choice = rec.choice
      addrarr.push(add)
    end
    render json: params[:callback]+'({"recepits":'+addrarr.to_json+'})',content_type: "application/javascript"
  end
  def getrecepitone
    recepit=Recepitaddre.where('user_id = ? and id = ?',@userid[0].id,params[:id])
    addrarr = Array.new
    add = Adder.new
    add.id = recepit[0].id
    add.name = recepit[0].name
    add.tel = recepit[0].tel
    add.region = recepit[0].region
    add.address = recepit[0].address
    add.choice = recepit[0].choice
    addrarr.push(add)
    render json: params[:callback]+'({"recepits":'+addrarr.to_json+'})',content_type: "application/javascript"
  end
  def getreceoitedit
    recdata=Recepitaddre.where('user_id = ? and id = ?',@userid[0].id,params[:id])
    rec=Recepitaddre.find(recdata[0].id)

    rec.name=params[:name]
    rec.tel=params[:tel]
    rec.region=params[:region]
    rec.address=params[:address]
    rec.save
    render json: params[:callback]+'({"recepits":'+'1'+'})',content_type: "application/javascript"  #权限管理
  end
  def getreceoitadd
    rec=Recepitaddre.new
    rec.user_id=@userid[0].id
    rec.name=params[:name]
    rec.tel=params[:tel]
    rec.region=params[:region]
    rec.address=params[:address]
    rec.choice=0;
    rec.save
    render json: params[:callback]+'({"recepits":'+'1'+'})',content_type: "application/javascript"  #权限管理
  end
  def getreceoitdel
    recdata=Recepitaddre.where('user_id = ? and id = ?',@userid[0].id,params[:id])
    rec=Recepitaddre.find(recdata[0].id)
    rec.destroy
    render json: params[:callback]+'({"recepits":'+'1'+'})',content_type: "application/javascript"  #权限管理
  end
  def getreceoitdefault
    recdata=Recepitaddre.where('user_id = ? and choice = 1',@userid[0].id)
    recdata.each do |recone|
      recone.choice=0
      recone.save
    end
    rec=Recepitaddre.find(params[:id])
    rec.choice=1
    rec.save
    render json: params[:callback]+'({"recepits":'+'1'+'})',content_type: "application/javascript"  #权限管理
  end
  class Buycarlist
    attr :id,true
    attr :name,true
    attr :money,true
    attr :const,true
    attr :status,true
  end
  def getbuycarlist
    if params[:type]
      buycar = Buycar.where('selleruser_id in (?) and status = ?',@userid.ids,params[:type])
    else
      buycar = Buycar.where('selleruser_id in (?)',@userid.ids)
    end
    buycararr = Array.new
    buycar.each do |buy|
      buycla = Buycarlist.new
      buycla.id = buy.id
      buycla.name = Seller.find(buy.seller_id).name
      buycla.money = buy.amount
      buycla.const = buy.ordernumber
      buycla.status = buy.status
      buycararr.push(buycla)
    end
    render json: params[:callback]+'({"buycar":'+buycararr.to_json+'})',content_type: "application/javascript"
  end
  class Arrcon
    attr :id,true
    attr :con,true
  end
  def getbuycarfrom
    ids=params[:ids].split(',')
    cons=params[:con].split(',')
    arrercon=Array.new
    length = ids.length-1
    for i in 0..length do
      arr = Arrcon.new
      arr.id = ids[i]
      arr.con = cons[i]
      arrercon.push(arr)
    end
    #openid=params[:openid]
    #upid=params[:upid]
      sellerid=Seller.find(ids[0])
      selluser=Selleruser.new
      selluser.seller_id=sellerid.id
      selluser.save
    buycar=Buycar.new
    buycar.selleruser_id=selluser.id
    buycar.save
    shulian=0
    zongjia=0.00
    arrercon.each do |ide|
      order=Order.new
      order.buycar_id=buycar.id
      order.product_id=ide.id
      order.number=ide.con
      order.price=Product.find(ide.id).price
      order.save
      shulian=shulian+1
      mon=order.price.to_f
      sun=ide.con.to_f
      zongjia=mon*sun+zongjia
    end
    buycar.ordernumber=shulian
    buycar.amount=zongjia
    buycar.status=0
    buycar.seller_id=sellerid.id
    buycar.save
    #buycar = Buycar.new()
    #buycar.sava

    #buycar.orders.create([{ :percent => 0,:object_id => "1" :percent => 1, :object_id => "2"}])

    produ=Product.where("id in (?)",params[:ids].split(','))
    render json: params[:callback]+'({"produ":'+buycar.to_json+'})',content_type: "application/javascript"
  end

  def weixingetpost
    result=request.body.read
    res=result.to_s
    if res.match("xml")[0]
      weixin = Hash.from_xml(res)
      weixin=weixin["xml"]
      if weixin["Event"] == "subscribe" && weixin["MsgType"] == "event"
        seller=Selleruser.where("openid = ?",weixin["FromUserName"])
        if seller.length == 0
          seller=Selleruser.where("qrcode = ?",weixin["EventKey"])
          sellernew=Selleruser.new
          sellernew.openid=weixin["FromUserName"]
          if seller.length>0
            sellernew.up_id=seller[0].id
            sellernew.seller_id=seller[0].seller_id
          else
            selname=Seller.where("weixinname = ? ",weixin["ToUserName"])
            sellernew.seller_id=selname[0].id
          end

          user=User.new
          user.save
          sellernew.user_id=user.id
          sellernew.save
          selname=Seller.find(sellernew.seller_id)
          token = getaccesstoken(sellernew.seller_id)
          postcustomtext(token,sellernew.openid,"恭喜您，已成功关注“"+selname.name.to_s+'”')
          if seller.length>0
            token = getaccesstoken(seller[0].seller_id)
            postcustomtext(token,seller[0].openid,"恭喜您，有一人通过扫描您的二维码关注了“"+selname.name.to_s+'”')
          end
        else
          token = getaccesstoken(seller[0].seller_id)
          postcustomtext(token,seller[0].openid,"欢迎您再次回来")
        end
      end
    end
    weixinlog=Weixinlog.new
    weixinlog.url = request.query_parameters.to_s
    weixinlog.log = res
    weixinlog.save
    if params[:echostr]
      render json: params[:echostr]
    end
    render json: '({"subscribe":200})',content_type: "application/javascript"
  end

  def getweixinimg
    seller=Selleruser.where(" openid = ? ",params[:openid])
    buycar=Buycar.where("selleruser_id = ? and status >0 and status <10",seller[0].id)
    if buycar.length > 0
      token = getaccesstoken(seller[0].seller_id)
      ticket=getticket(token,seller[0].id)
      render json: params[:callback]+'({"ticket":"'+ ticket+'","err":"正确"})',content_type: "application/javascript"
    else
      render json: params[:callback]+'({"err":"错误"})',content_type: "application/javascript"
    end
  end

  def getwxopenid
    seller = Seller.find(params[:state])
    openid = getopenid(seller.appid,seller.secret,params[:code])
    redirect_to "threefront.posan.biz?openid=" + openid.to_s
  end
end
