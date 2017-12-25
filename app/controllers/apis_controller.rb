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
    productls=Product.where("id = ?",params[:id])
    if productls.length>0
      productls=productls[0]
      productarr = Array.new

      pclass = Pronameclass.new
      pclass.id = productls.id
      pclass.productimg = productls.productimg.url
      pclass.name = productls.name
      pclass.money = productls.price
      productarr.push(pclass)

      render json: params[:callback]+'({"products":'+productarr.to_json+'})',content_type: "application/javascript"
    else
      render json: '({"err":"404"})',content_type: "application/javascript"
    end

  end
  class Proname
    attr :id,true
    attr :name,true
    attr :content,true
  end

  def getproductcontent
    productnas=Product.where("id = ?",params[:id])
    if productnas.length>0
      productnas=productnas[0]
      productarr = Array.new
      ser=Seller.find(productnas.seller_id)
      pcont= Proname.new
      pcont.id = productnas.id
      pcont.name = ser.name
      pcont.content = productnas.content
      productarr.push(pcont)

      render json: params[:callback]+'({"products":'+ productarr.to_json + '})',content_type: "application/javascript"
    else
      render json: '({"err":"404"})',content_type: "application/javascript"
    end

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
    render json: params[:callback]+'({"recepits":'+rec.id.to_s+'})',content_type: "application/javascript"  #权限管理
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
      buycla.const = buy.num
      buycla.status = buy.status
      buycararr.push(buycla)
    end
    render json: params[:callback]+'({"buycar":'+buycararr.to_json+'})',content_type: "application/javascript"
  end
  class Ordercla
    attr :id,true
    attr :name,true
    attr :money,true
    attr :productimg,true
    attr :const,true
    attr :product_id,true
  end
  class Logisticordercla
    attr :id,true
    attr :name,true
    attr :ordernumber,true
  end
  def getbuycarfrom
    buycar = Buycar.find(params[:id])
    order=Order.where("buycar_id = ?",buycar.id)
    receive=Receive.where("buycar_id = ?",buycar.id)
    orderarr = Array.new
    order.each do |ord|
      ordcla = Ordercla.new
      ordcla.id = ord.id
      ordcla.name = ord.name
      ordcla.money = ord.price
      produ=Product.find(ord.product_id)
      ordcla.productimg = produ.productimg.url
      ordcla.const = ord.number
      ordcla.product_id = ord.product_id
      orderarr.push(ordcla)
    end
    receive = receive[0]
    logisticorder = Logisticorder.where("buycar_id = ?",buycar.id)
    logarr = Array.new
    logisticorder.each do |log|
      logcla = Logisticordercla.new
      logcla.name = log.logistic.logistic
      logcla.ordernumber = log.ordernumber
      logarr.push(logcla)
    end
    render json: params[:callback]+'({"buycar":'+buycar.to_json+',"order":'+orderarr.to_json+',"receive":'+receive.to_json+',"logisticorder":'+logarr.to_json+'})',content_type: "application/javascript"
  end

  def getbuycaradd
    ids=params[:ids].split(',')
    cons=params[:con].split(',')
    buycar=Buycar.new
    selluser = Selleruser.where(" openid = ? ",params[:openid])

    if selluser[0].repeatshop > 0
      buycar.shopstatic=1
    else
      buycar.shopstatic=0
    end
    buycar.selleruser_id=selluser[0].id
    buycar.seller_id=selluser[0].seller_id
    buycar.user_id = selluser[0].user_id
    buycar.save

    length = ids.length-1
    shulian=0
    zongjia=0.00
    firstzj=0.00
    secondzj=0.00
    thirdzj=0.00
    for i in 0..length do
      product=Product.find(ids[i])
      order=Order.new
      order.buycar_id=buycar.id
      order.product_id=product.id
      order.number=cons[i].to_i
      shulian=shulian + cons[i].to_i
      order.name=product.name
      order.spec=product.spec
      order.model=product.model

      if buycar.shopstatic == 1
        order.shopstatus=1
        order.price=product.secondprice
        order.first=product.sfirst
        order.second=product.ssecond
        order.third=product.sthird
      else
        order.shopstatus=0
        order.price=product.price
        order.first=product.first
        order.second=product.second
        order.third=product.third
      end
      jiage=order.price.to_f * order.number.to_f
      firstzj=order.first.to_f * order.number.to_f
      secondzj=order.second.to_f * order.number.to_f
      thirdzj=order.third.to_f * order.number.to_f
      zongjia=zongjia + jiage
      order.save
    end
    buycar.first=firstzj
    buycar.second=secondzj
    buycar.third=thirdzj
    buycar.num=shulian
    buycar.amount=zongjia
    buycar.status=0
    buycar.save
    if selluser[0].up_id
      thirupid(3,selluser[0].up_id,buycar.id)
    end
    receive=Receive.new
    addr=Recepitaddre.where("user_id = ?",selluser[0].user_id)
    if addr.length > 0
      addrcho=Recepitaddre.where("user_id = ? and choice = 1",selluser[0].user_id)
      if addrcho.length > 0
        receive.name=addrcho[0].name
        receive.tel=addrcho[0].tel
        receive.region=addrcho[0].region
        receive.address=addrcho[0].address
      else
        receive.name=addr[0].name
        receive.tel=addr[0].tel
        receive.region=addr[0].region
        receive.address=addr[0].address
      end
    end
    receive.buycar_id=buycar.id
    receive.save
    render json: params[:callback]+'({"buycar":'+ buycar.id.to_s + '})',content_type: "application/javascript"
  end

  def thirupid(num,id,buyid)
    if(num>0 && id)
      buycar = Buycar.find(buyid)
      selluser = Selleruser.find(id)
      user = User.find(selluser.user_id)
      if(num == 1)
        user.undthird = user.undthird.to_f + buycar.first.to_f
      elsif (num == 2)
        user.undsenond = user.undsenond.to_f + buycar.second.to_f
      elsif (num == 3)
        user.undfirst = user.undfirst.to_f + buycar.third.to_f
      end
      num = num - 1
      user.save
      if num > 1
        thirupid(num,selluser.up_id,buyid)
      end
    end
  end
  def setreceive
    selleruser=Selleruser.where("openid = ?",params[:openid])
    buycar=Buycar.where("selleruser_id = ? and id = ? and status = 0",selleruser[0].id,params[:bid])
    if(buycar.length > 0)
      receive=Receive.where("buycar_id = ?",params[:bid])
      receive=receive[0]
      addr=Recepitaddre.find(params[:id])
      receive.name=addr.name
      receive.tel=addr.tel
      receive.region=addr.region
      receive.address=addr.address
      receive.save
    end
    render json: params[:callback] + '({"receive":'+receive.to_json+'''})',content_type: "application/javascript"
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
    if seller[0].repeatshop > 0
      token = getaccesstoken(seller[0].seller_id)
      ticket=getticket(token,seller[0].id)
      render json: params[:callback]+'({"ticket":"'+ ticket+'","err":"正确"})',content_type: "application/javascript"
    else
      render json: params[:callback]+'({"err":"错误"})',content_type: "application/javascript"
    end
  end

  def getbuycarplay
    buycar=Buycar.where("id = ?",params[:id])
    if buycar.length > 0
      buycar=buycar[0]
      seller=Selleruser.where("openid = ?",params[:openid])
      seller=seller[0]
      if(buycar.selleruser_id == seller.id)#判断支付金额是否对
        buycar.status=1
        buycar.remark=params[:name]
        buycar.save
        render json: params[:callback]+'({"buycar":"'++buycar.id.to_s++'"})',content_type: "application/javascript"
      end
    else
      render json: '({"err":404})',content_type: "application/javascript"
    end
  end

  def getbuycarconfirm
    buycar=Buycar.where("id = ?",params[:id])
    if buycar.length > 0
      buycar=buycar[0]
      seller=Selleruser.where("openid = ?",params[:openid])
      seller=seller[0]
      if(buycar.selleruser_id == seller.id)#判断支付金额是否对
        buycar.status=3
        buycar.save
        seller.repeat=1
        seller.save
        render json: params[:callback]+'({"buycar":"'++buycar.id.to_s++'"})',content_type: "application/javascript"
      end
    else
      render json: '({"err":404})',content_type: "application/javascript"
    end
  end

  def getwxopenid
    seller = Seller.find(params[:state])
    openid = getopenid(seller.appid,seller.secret,params[:code])
    redirect_to "http://threefront.posan.biz?openid=" + openid.to_s
  end

  class Userupcla
    attr :id,true
    attr :name,true
    attr :upname,true
  end

  def getuserupname  #会员ID
    selleruser=Selleruser.where("openid = ?",params[:openid])
    selleruser=selleruser[0]
    userfrom = Userupcla.new
    userfrom.id=1
    user=User.find(selleruser.user_id)
    if user.name != nil
      userfrom.name=user.name
    else
      userfrom.name="无名"
    end

    if selleruser.up_id
      selleruser=Selleruser.find(selleruser.up_id)
      user=User.find(selleruser.user_id)
      if user.name != nil
        userfrom.upname=user.name
      else
        userfrom.name="无名"
      end
    else
      userfrom.upname="o(╥﹏╥)o没有人了"
    end
    render json: params[:callback]+'({"user":'+userfrom.to_json+'})',content_type: "application/javascript"
  end

  def setuserupname
    selleruser=Selleruser.where("openid = ?",params[:openid])
    if selleruser.length >0
      selleruser=selleruser[0]
      user=User.find(selleruser.user_id)
      user.name=params[:name]
      user.save
      render json: params[:callback]+'({"err":"0"})',content_type: "application/javascript"
    else
      render json: params[:callback]+'({"err":"404"})',content_type: "application/javascript"
    end
  end

  def getthreename
    selleruser=Selleruser.where("openid = ?",params[:openid])
    if selleruser.length >0
      selleruser=selleruser[0]
      user = ActiveRecord::Base.connection.select_all "SELECT b.id,a.name,b.up_id FROM users a,sellerusers b where a.id=b.user_id and a.id in (select user_id from sellerusers where up_id in (select id from sellerusers where up_id = "+selleruser.id.to_s+"))"
      render json: params[:callback]+'({"user":'+user.to_json+'})',content_type: "application/javascript"
    else
      render json: params[:callback]+'({"err":"404"})',content_type: "application/javascript"
    end
  end

  def getreferralname
    selleruser=Selleruser.where("openid = ?",params[:openid])
    if selleruser.length >0
      selleruser=selleruser[0]
      user = ActiveRecord::Base.connection.select_all "SELECT b.id,a.name,b.up_id FROM users a,sellerusers b where a.id=b.user_id and a.id in (select user_id from sellerusers where up_id in (select id from sellerusers where up_id = "+selleruser.id.to_s+" or id = "+selleruser.id.to_s+"))"
      render json: params[:callback]+'({"user":'+user.to_json+'})',content_type: "application/javascript"
    else
      render json: params[:callback]+'({"err":"404"})',content_type: "application/javascript"
    end
  end

  def getsenondname
    selleruser=Selleruser.where("openid = ?",params[:openid])
    if selleruser.length >0
      selleruser=selleruser[0]
      user = ActiveRecord::Base.connection.select_all "SELECT b.id,a.name,b.up_id FROM users a,sellerusers b where a.id=b.user_id and a.id in (select user_id from sellerusers where up_id in (select id from sellerusers where id = "+selleruser.id.to_s+"))"
      render json: params[:callback]+'({"user":'+user.to_json+'})',content_type: "application/javascript"
    else
      render json: params[:callback]+'({"err":"404"})',content_type: "application/javascript"
    end
  end
end
