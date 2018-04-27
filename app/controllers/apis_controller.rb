class ApisController < ApplicationController
  $postthwxpay = 'http://coffeeadmin.posan.biz/wxpayments/cdzycrlz?callback=Wzx0xjG5'
  $posanappid = 'wx5726c31c9832f709'
  require "rexml/document"
  include REXML
  before_action :set_openid, only: [:getbuycardel, :getnotice, :getbuycarlist, :getproductlist, :getbuycartruemoney, :getproname, :getproductcontent, :getrecepit, :getreceoitadd, :getrecepitone, :getreceoitedit, :getreceoitdel, :getreceoitdefault, :getbuycarfrom, :getbuycaradd, :setreceive, :getweixinimg, :getbuycarplay, :getbuycarconfirm, :getuserupname, :setuserupname, :getthreename, :getreferralname, :getsenondname, :getwxpublicqrcode, :getsellerqrcode, :getuserpswds, :setuserpswds, :getak, :getwxgetrich, :getsystemlog, :getbuycaraftersales, :setafterone, :getafterlogistics, :setlogistics]
  skip_before_action :verify_authenticity_token, :only => [:weixingetpost, :prepaytrue]

  def set_openid
    if (params[:openid] != "") && (params[:sid] != "")
      @selleruser = Selleruser.where(" openid = ? and seller_id = ?",params[:openid],params[:sid])
      if @selleruser.length > 0

      else
        render json: '({"err":"错误"})',content_type: "application/javascript"
      end
    else
      render json: '({"err":"错误"})',content_type: "application/javascript"
    end
  end

  class Noticecla
    attr :id,true
    attr :img,true
  end

  def getnotice
    if (params[:openid] != "") && (params[:sid] != "")
      notice = Notice.where('seller_id = ? and status = 1',@selleruser[0].seller_id).order('updated_at desc').limit(5)
      noticeall = Array.new
      notice.each do |pro|
        nclass = Noticecla.new
        nclass.id = pro.id
        nclass.img = pro.noticeimg.url
        noticeall.push(nclass)
      end
      render json: params[:callback]+'({"notice":' + noticeall.to_json + '})',content_type: "application/javascript"
    else
      render json: params[:callback]+'({"err":"错误"})',content_type: "application/javascript"
    end
  end

  class Prolist
    attr :id,true
    attr :productimg,true
  end

  def getproductlist
    if params[:openid] != ""
      productls=Product.where('seller_id = ? and status = 1',@selleruser[0].seller_id).limit((params[:num].to_i * 5).to_s + ",5")#paginate(:page => params[:num], :per_page => 5).order("id desc")
      productarr = Array.new
      productls.each do |pro|
        pclass = Prolist.new
        pclass.id = pro.id
        pclass.productimg = pro.productimg.url
        productarr.push(pclass)
      end
      render json: params[:callback]+'({"products":'+productarr.to_json+'})',content_type: "application/javascript"
    else
      render json: params[:callback]+'({"err":"错误"})',content_type: "application/javascript"
    end

  end
  class Pronameclass
    attr :id,true
    attr :productimg,true
    attr :name,true
    attr :money,true
    attr :rep,true
  end

  def getproname
    productls = Product.where("id = ? and seller_id = ?", params[:id],@selleruser[0].seller_id)
    if productls.length > 0
      productls=productls[0]
      productarr = Array.new

      pclass = Pronameclass.new
      pclass.id = productls.id
      pclass.productimg = productls.productimg.url
      pclass.name = productls.name
      if @selleruser[0].repeatshop.to_i > 0
        pclass.money = productls.secondprice
      else
        pclass.money = productls.price
      end
      pclass.rep = @selleruser[0].repeatshop.to_i
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
    productnas=Product.where("id = ? and seller_id = ?", params[:id],@selleruser[0].seller_id)
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
    recepit = Recepitaddre.where('user_id = ?',@selleruser[0].user_id)
    if recepit.length > 0
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
      render json: params[:callback]+'({"recepits":' + addrarr.to_json + '})',content_type: "application/javascript"
    else
      render json: params[:callback]+'({"err":"404","recepits":[]})',content_type: "application/javascript"
    end
  end
  def getrecepitone
    recepit=Recepitaddre.where('user_id = ? and id = ?',@selleruser[0].user_id,params[:id])
    if recepit.length > 0
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
    else
      render json: '({"err":"404"})',content_type: "application/javascript"
    end
  end
  def getreceoitedit
    recdata=Recepitaddre.where('user_id = ? and id = ?',@selleruser[0].user_id,params[:id])
    if recdata.length > 0
      rec=Recepitaddre.find(recdata[0].id)

      rec.name=params[:name]
      rec.tel=params[:tel]
      rec.region=params[:region]
      rec.address=params[:address]
      rec.save
      render json: params[:callback]+'({"recepits":'+'1'+'})',content_type: "application/javascript"  #权限管理
    else
      render json: '({"err":"404"})',content_type: "application/javascript"
    end
  end
  def getreceoitadd
    rec = Recepitaddre.new
    rec.user_id = @selleruser[0].user_id
    rec.name = params[:name]
    rec.tel = params[:tel]
    rec.region = params[:region]
    rec.address = params[:address]
    rec.choice = 0
    rec.save
    render json: params[:callback]+'({"recepits":'+rec.id.to_s+'})',content_type: "application/javascript"  #权限管理
  end
  def getreceoitdel
    recdata = Recepitaddre.where('user_id = ? and id = ?',@selleruser[0].user_id,params[:id])
    if recdata.length > 0
      rec=Recepitaddre.find(recdata[0].id)
      rec.destroy
      render json: params[:callback]+'({"recepits":'+'1'+'})',content_type: "application/javascript"  #权限管理
    else
      render json: '({"err":"404"})',content_type: "application/javascript"
    end
  end
  def getreceoitdefault
    recdata = Recepitaddre.where('user_id = ? and choice = 1',@selleruser[0].user_id)
    if recdata.length > 0
      recdata.each do |recone|
        recone.choice=0
        recone.save
      end
      rec=Recepitaddre.find(params[:id])
      rec.choice=1
      rec.save
      render json: params[:callback]+'({"recepits":'+'1'+'})',content_type: "application/javascript"  #权限管理
    else
      rec=Recepitaddre.find(params[:id])
      rec.choice=1
      rec.save
      render json: params[:callback]+'({"recepits":'+'1'+'})',content_type: "application/javascript"  #权限管理
    end
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
      buycar = Buycar.where('selleruser_id in (SELECT id FROM sellerusers where user_id = ?) and status = ? and (deltype is null or deltype = 2)',@selleruser[0].user_id,params[:type]).order('created_at desc')
    else
      buycar = Buycar.where('selleruser_id in (SELECT id FROM sellerusers where user_id = ?) and (deltype is null or deltype = 2)',@selleruser[0].user_id).order('created_at desc')
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
  class Buycarcla
    attr :id,true
    attr :amount,true
    attr :num,true
    attr :remark,true
    attr :bpnum,true
    attr :bpoff,true
    attr :minusbpnum,true
    attr :status,true
    attr :dedmoney,true
  end
  def getbuycarfrom
    buycar = Buycar.where("selleruser_id in (SELECT id FROM sellerusers where user_id = ?) and id = ?",@selleruser[0].user_id,params[:id])
    if buycar.length > 0
      buycar = buycar[0]
      if (buycar.minusbpnum.to_i != 0) || (buycar.dedmoney.to_f != 0)
        buycar.amount = buycar.dedmoney.to_f + buycar.amount.to_f + (buycar.minusbpnum.to_f / 100)
        buycar.amount = sprintf("%.2f", buycar.amount)
        buycar.dedmoney = 0
        buycar.minusbpnum = 0
        buycar.save
      end
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
      buycla = Buycarcla.new
      buycla.id = buycar.id
      buycla.amount = buycar.amount
      buycla.num = buycar.num
      buycla.remark = buycar.remark
      buycla.bpnum = buycar.bpnum.to_i
      buycla.status = buycar.status
      user = User.find(@selleruser[0].user_id)
      buycla.bpoff = user.bpnum.to_i
      buycla.minusbpnum = buycar.minusbpnum.to_i
      buycla.dedmoney = sprintf("%.2f",user.first.to_f)
      if buycar.status == 0
        body = {"url" => params[:url].split('#')[0]}
        body = posthtml('http://coffeeadmin.posan.biz/apis/getconfig',body)
      else
        body = '"err"'
      end
      render json: params[:callback]+'({"buycar":'+buycla.to_json+',"order":'+orderarr.to_json+',"receive":'+receive.to_json+',"logisticorder":'+logarr.to_json+',"wxconfig":'+body.to_s+'})',content_type: "application/javascript"
    else
      render json: '({"err":"404"})',content_type: "application/javascript"
    end
  end

  def prepaytrue
    result=request.body.read.to_s
    wx = Weixinlog.new
    wx.log = result
    wx.save
    body = posthtml('http://coffeeadmin.posan.biz/apis/notify',{"body" => result})
    body = Hash.from_xml(body)
    body = body["xml"]
    result = Hash.from_xml(result)
    result = result["xml"]
    if body["return_code"] == "SUCCESS"
      buycar = Buycar.where('ordernumber = ?',result["out_trade_no"])
      if buycar.length > 0
        buycar = buycar[0]
        if (result["fee_type"] == "CNY") && ((buycar.amount*100).to_i == result["total_fee"].to_i)
          buycar.status = 2
          buycar.save
          seller = Selleruser.find(buycar.selleruser_id)
          if seller.up_id
            thirupid(3,seller.up_id,buycar.id)
          end
          systemls = seller.systemlogs.new
          systemls.table = "buycar"
          systemls.userid = buycar.id
          systemls.userip = request.remote_ip
          systemls.textout = "您于" + Time.new.strftime("%Y-%m-%d %H:%M:%S") + "支付了一个订单的款项，共计支付了¥" + buycar.amount.to_s + "。"
          systemls.save
          modelout(seller.seller_id,4,seller.openid,buycar.id)
        end
      end
    end
    render :xml => {return_code: "SUCCESS"}.to_xml(root: 'xml', dasherize: false)
  end

  def getbuycarplay
    buycar=Buycar.where("id = ?",params[:id])
    if (buycar.length > 0) && (buycar[0].selleruser_id == @selleruser[0].id)
      buycar=buycar[0]
      if (buycar.minusbpnum.to_i != 0) || (buycar.dedmoney.to_f != 0)
        buycar.amount = buycar.dedmoney.to_f + buycar.amount.to_f + (buycar.minusbpnum.to_f / 100)
        buycar.amount = sprintf("%.2f", buycar.amount)
        buycar.dedmoney = 0
        buycar.minusbpnum = 0
      end
      user = User.find(@selleruser[0].user_id)
      bpnum = 0.00
      dedmoney = 0.00
      if params[:bpnum].to_s == "1" #只使用积分
        if user.bpnum > 0
          bpnum = (user.bpnum.to_i)/100.00
          money = buycar.amount.to_f
          if money >= bpnum
            money = money - bpnum
            buycar.minusbpnum = user.bpnum
            user.bpnum = 0
            buycar.amount = sprintf("%.2f",money)
          else
            user.bpnum = sprintf("%.0f",((bpnum - money)*100))
            buycar.amount = 0
            buycar.minusbpnum = sprintf("%.0f",( money*100)).to_i
          end
        end
      end
      if params[:bpnum].to_s == "2" #只使用余额
        if user.first > 0
          dedmoney = user.first
          money = buycar.amount.to_f
          if money >= dedmoney
            money = money - dedmoney
            user.first = 0
            buycar.amount = sprintf("%.2f",money)
            buycar.dedmoney = dedmoney
          else
            user.first = sprintf("%.2f",(dedmoney - money))
            buycar.amount = 0
            buycar.dedmoney = money
          end
        end
      end
      if params[:bpnum].to_s == "3" #两种都使用的
        if user.bpnum > 0
          bpnum = (user.bpnum.to_i)/100.00
          money = buycar.amount.to_f
          if money >= bpnum
            money = money - bpnum
            buycar.minusbpnum = user.bpnum
            user.bpnum = 0
            buycar.amount = sprintf("%.2f",money)
          else
            user.bpnum = sprintf("%.0f",((bpnum - money)*100))
            buycar.amount = 0
            buycar.minusbpnum = sprintf("%.0f",( money*100)).to_i
          end
        end
        if user.first > 0
          dedmoney = user.first
          money = buycar.amount.to_f
          if money >= dedmoney
            money = money - dedmoney
            user.first = 0
            buycar.amount = sprintf("%.2f",money)
            buycar.dedmoney = dedmoney
          else
            user.first = sprintf("%.2f",(dedmoney - money))
            buycar.amount = 0
            buycar.dedmoney = money
          end
        end
      end
      buycar.remark = params[:name]
      buycar.save
      if buycar.amount > 0
        seller = Seller.find(@selleruser[0].seller_id)
        body = {"ordernumber" => buycar.ordernumber, "name" => seller.name, "openid" => @selleruser[0].openidposan, "amount" => buycar.amount}
        body = posthtml('http://coffeeadmin.posan.biz/apis/getprepay',body)
      else
        body = '{"pay_ticket_param":{"err":"404"}}'
      end
      render json: params[:callback]+'({"buycar":"'+buycar.id.to_s+'","pay":'+body+'})',content_type: "application/javascript"
    else
      render json: '({"err":404})',content_type: "application/javascript"
    end
  end

  def getbuycartruemoney
    userak = Userpwd.find(@selleruser[0].user_id)
    if userak.ak == params[:ak]
      buycar = Buycar.where("id = ?",params[:id])
      if (buycar.length > 0) && (buycar[0].status == 0) && (buycar[0].selleruser_id == @selleruser[0].id)
        buycar=buycar[0]
        if buycar.amount > 0
          render json: params[:callback]+'({"err":"404"})',content_type: "application/javascript"
        else
          buycar.status=2
          buycar.save
          seller = @selleruser[0]
          if seller.up_id
            thirupid(3,seller.up_id,buycar.id)
          end
          systemls = seller.systemlogs.new
          systemls.table = "buycar"
          systemls.userid = buycar.id
          systemls.userip = request.remote_ip
          systemls.textout = "您于" + Time.new.strftime("%Y-%m-%d %H:%M:%S") + "支付了一个订单的款项，共计支付了¥" + buycar.amount.to_s + "。"
          systemls.save
          modelout(seller.seller_id,4,seller.openid,buycar.id)
          render json: params[:callback]+'({"err":"ok"})',content_type: "application/javascript"
        end
      else
        render json: params[:callback]+'({"err":404})',content_type: "application/javascript"
      end
    else
      render json: params[:callback]+'({"err":404})',content_type: "application/javascript"
    end
  end

  def getbuycaradd    #存在产品ID没做验证
    selluser = @selleruser
    ids=params[:ids].split(',')
    cons=params[:con].split(',')
    errdisk = Product.where("id in (?) and seller_id <> ?",ids,params[:sid])
    if errdisk.length > 0
      render json: '({"err":"404"})',content_type: "application/javascript"
    else
      buycar = Buycar.new

      if selluser[0].repeatshop.to_i > 0
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
      bp = 0.00
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
          order.bpnum=product.sbpnum
        else
          order.shopstatus=0
          order.price=product.price
          order.first=product.first
          order.second=product.second
          order.third=product.third
          order.bpnum=product.bpnum
        end
        order.first = sprintf("%.2f",order.first).to_f
        order.second = sprintf("%.2f",order.second).to_f
        order.third = sprintf("%.2f",order.third).to_f
        order.price = sprintf("%.2f",order.price).to_f

        jiage=order.price.to_f * order.number.to_f
        firstzj= firstzj + sprintf("%.2f",(order.first.to_f * order.number.to_f)).to_f
        secondzj= secondzj + sprintf("%.2f",(order.second.to_f * order.number.to_f)).to_f
        thirdzj= thirdzj + sprintf("%.2f",(order.third.to_f * order.number.to_f)).to_f
        bp = bp + order.bpnum.to_i * order.number.to_i
        zongjia=zongjia + jiage
        order.save
      end
      buycar.bpnum = bp
      firstzj = sprintf("%.2f",firstzj).to_f
      secondzj = sprintf("%.2f",secondzj).to_f
      thirdzj = sprintf("%.2f",thirdzj).to_f
      zongjia = sprintf("%.2f",zongjia).to_f
      buycar.first=firstzj
      buycar.second=secondzj
      buycar.third=thirdzj
      buycar.num=shulian
      buycar.amount=zongjia
      buycar.status=0
      buycar.save
      buycar.ordernumber = Time.now.strftime('%Y%m%d%H%M%S') + buycar.id.to_s
      buycar.save
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
      systemls = selluser[0].systemlogs.new
      systemls.table = "buycar"
      systemls.userid = buycar.id
      systemls.userip = request.remote_ip
      systemls.textout = "您于" + Time.new.strftime("%Y-%m-%d %H:%M:%S") + "下了一个订单。"
      systemls.save
      modelout(selluser[0].seller_id,3,selluser[0].openid,buycar.id)
      render json: params[:callback]+'({"buycar":'+ buycar.id.to_s + '})',content_type: "application/javascript"
    end
  end

  def thirupid(num,id,buyid)
    if(num>0 && id)
      buycar = Buycar.find(buyid)
      selluser = Selleruser.find(id)
      user = User.find(selluser.user_id)
      if(num == 1)
        user.undthird = user.undthird.to_f + buycar.third.to_f
        user.undthird = sprintf("%.2f",user.undthird)
      elsif (num == 2)
        user.undsenond = user.undsenond.to_f + buycar.second.to_f
        user.undsenond = sprintf("%.2f",user.undsenond)
      elsif (num == 3)
        user.undfirst = user.undfirst.to_f + buycar.first.to_f
        user.undfirst = sprintf("%.2f",user.undfirst)
      end
      modelout(selluser.seller_id,5,selluser.openid,buycar.id)
      num = num - 1
      user.save
      if num > 1
        thirupid(num,selluser.up_id,buyid)
      end
    end
  end

  def setreceive
    selleruser = @selleruser
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

  def setafterone
    buycar=Buycar.where("selleruser_id = ? and id = ?",@selleruser[0].id,params[:id])
    if buycar.length > 0
      buycar = buycar[0]
      retof = Retoforder.new
      retof.buycar_id = buycar.id
      retof.selleruser_id = @selleruser[0].id
      if params[:rettype] == '1'
        retof.rettype = 1
        retof.ordertype = 1
        buycar.status = 11
      else
        retof.rettype = 11
        retof.ordertype = 2
        buycar.status = 12
      end
      retof.other = params[:userexplain]
      retof.retreason = params[:usertype]
      retof.retcomment = params[:usertext]
      retof.retmoney = params[:usermoney].to_f
      retof.save
      buycar.save
      systemls = @selleruser[0].systemlogs.new
      systemls.table = "retoforder"
      systemls.userid = retof.id
      systemls.userip = request.remote_ip
      systemls.textout = "您于" + Time.new.strftime("%Y-%m-%d %H:%M:%S") + "申请了售后服务，并且填写了相关信息。"
      systemls.save
      render json: params[:callback] + '({"err":"OK"})',content_type: "application/javascript"
    else
      render json: '({"err":404})',content_type: "application/javascript"
    end
  end

  def getlogistics
    logistics = Logistic.all
    render json: params[:callback] + '({"logistics":' + logistics.to_json + '})',content_type: "application/javascript"
  end

  def setlogistics
    retof = Retoforder.find(params[:id])
    if ( params[:order].to_i > 0 ) && (params[:num] != "")
      log = Logistic.find(params[:order])
      retof.logisticname = log.logistic
      retof.logisticnum = params[:num]
      retof.rettype = 13
      retof.save
      systemls = @selleruser[0].systemlogs.new
      systemls.table = "retoforder"
      systemls.userid = retof.id
      systemls.userip = request.remote_ip
      systemls.textout = "您于" + Time.new.strftime("%Y-%m-%d %H:%M:%S") + "填写了售后的快递公司及快递单号。"
      systemls.save
      render json: params[:callback] + '({"err":"OK"})',content_type: "application/javascript"
    else
      render json: params[:callback] + '({"err":404})',content_type: "application/javascript"
    end
  end

  def getafterlogistics
    buycar = Buycar.where("selleruser_id = ? and id = ?",@selleruser[0].id,params[:id])
    if buycar.length > 0
      retof = Retoforder.where('buycar_id = ?',buycar[0].id)
      if retof.length > 0
        retof = retof[0]
        render json: params[:callback] + '({"retoforder":' + retof.to_json + '})',content_type: "application/javascript"
      else
        render json: '({"err":404})',content_type: "application/javascript"
      end
    else
      render json: '({"err":404})',content_type: "application/javascript"
    end
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
          sellernew.repeatshop=0
          sellernew.openid=weixin["FromUserName"]
          if seller.length > 0
            sellernew.up_id=seller[0].id
            sellernew.seller_id=seller[0].seller_id
          else
            selname=Seller.where("weixinname = ? ",weixin["ToUserName"])
            sellernew.seller_id=selname[0].id
          end

          token = getaccesstoken(seller[0].seller_id)
          img = gethtml('https://api.weixin.qq.com/cgi-bin/user/info?access_token=' + token + '&openid=' + sellernew.openid + '&lang=zh_CN')
          img = JSON.parse(img)

          user=User.new
          user.name=img['nickname']
          user.third=0
          user.senond=0
          user.first=0
          user.undthird=0
          user.undsenond=0
          user.undfirst=0
          user.save
          sellernew.user_id=user.id
          sellernew.save
          modelout(sellernew.seller_id,1,sellernew.openid,0)

          #selname=Seller.find(sellernew.seller_id)
          #token = getaccesstoken(sellernew.seller_id)
          #postcustomtext(token,sellernew.openid,"恭喜您，已成功关注“" + selname.name.to_s + '”')
          if seller.length > 0
            modelout(seller[0].seller_id,2,seller[0].openid,user.id)
            #postcustomtext(token,seller[0].openid,"恭喜您，有一人通过扫描您的二维码关注了“"+selname.name.to_s+'”')
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
    seller = @selleruser
    if seller[0].repeatshop.to_i > 0
      token = getaccesstoken(seller[0].seller_id)
      ticket=getticket(token,seller[0].id)
      render json: params[:callback]+'({"ticket":"' + ticket + '","err":"正确"})',content_type: "application/javascript"
    else
      render json: params[:callback]+'({"err":"错误"})',content_type: "application/javascript"
    end
  end

  def getbuycarconfirm
    buycar=Buycar.where("id = ? and selleruser_id = ?",params[:id],@selleruser[0].id)
    if (buycar.length > 0) && (buycar[0].status == 3)
      buycar=buycar[0]
      seller = @selleruser[0]
      seller.repeatshop=1
      seller.save
      if(buycar.selleruser_id == seller.id)
        user = User.find(seller.user_id)
        user.bpnum = user.bpnum.to_i + buycar.bpnum.to_i
        user.save
        buycar.status=4
        buycar.save
        thirupmoney(3,seller.up_id,buycar.id)
        systemls = seller.systemlogs.new
        systemls.table = "buycar"
        systemls.userid = buycar.id
        systemls.userip = request.remote_ip
        systemls.textout = "您于" + Time.new.strftime("%Y-%m-%d %H:%M:%S") + "确认收货，订单号为" + buycar.ordernumber + "。"
        systemls.save
        render json: params[:callback]+'({"buycar":"'+buycar.id.to_s+'"})',content_type: "application/javascript"
      end
    else
      render json: '({"err":404})',content_type: "application/javascript"
    end
  end

  def getbuycaraftersales
    buycar=Buycar.where("id = ? and selleruser_id = ?",params[:id],@selleruser[0].id)
    if (buycar.length > 0) && (buycar[0].status == 3)
      buycar=buycar[0]
      buycar.status=12
      buycar.save
      render json: params[:callback] + '({"err":"OK"})',content_type: "application/javascript"
    else
      render json: params[:callback] + '({"err":404})',content_type: "application/javascript"
    end
  end

  def thirupmoney(num,id,buyid)
    if(num > 0 && id)
      buycar = Buycar.find(buyid)
      selluser = Selleruser.find(id)
      user = User.find(selluser.user_id)
      if(num == 1)
        user.undthird = user.undthird.to_f - buycar.third.to_f
        user.undthird = sprintf("%.2f",user.undthird)
        user.third = user.third.to_f + buycar.third.to_f
        user.third = sprintf("%.2f",user.third)
      elsif (num == 2)
        user.undsenond = user.undsenond.to_f - buycar.second.to_f
        user.undsenond = sprintf("%.2f",user.undsenond)
        user.senond = user.senond.to_f + buycar.second.to_f
        user.senond = sprintf("%.2f",user.senond)
      elsif (num == 3)
        user.undfirst = user.undfirst.to_f - buycar.first.to_f
        user.undfirst = sprintf("%.2f",user.undfirst)
        user.first = user.first.to_f + buycar.first.to_f
        user.first = sprintf("%.2f",user.first)
      end
      modelout(selluser.seller_id,6,selluser.openid,buycar.id)
      num = num - 1
      user.save
      if num > 1
        thirupmoney(num,selluser.up_id,buyid)
      end
    end
  end

  def getwxopenid
    seller = Seller.find(params[:state])
    openid = getopenid(seller.appid,seller.secret,params[:code])
    selleruser = Selleruser.where('seller_id = ? and openid = ?' ,seller.id ,openid)
    if selleruser.length > 0
      if selleruser[0].openidposan.to_s == ''
        redirect_to 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=' + $posanappid.to_s + '&redirect_uri=http%3a%2f%2fcoffeeadmin.posan.biz%2fapis%2fthreeopenid&response_type=code&scope=snsapi_base&state=' + selleruser[0].id.to_s + '#wechat_redirect'
      else
        redirect_to "http://threefront.posan.biz?openid=" + openid.to_s + "&sid=" + seller.id.to_s
      end
    else  #要不要跳转微信公众号
      redirect_to "http://threefront.posan.biz?openid=" + openid.to_s + "&sid=" + seller.id.to_s
    end
  end

  class Userupcla
    attr :id,true
    attr :name,true
    attr :upname,true
    attr :first,true
    attr :undfirst,true
    attr :img,true
    attr :bpnum,true
  end

  def getuserupname  #会员ID
    selleruser = @selleruser[0]
    userfrom = Userupcla.new
    userfrom.id=1
    user=User.find(selleruser.user_id)
    if user.name != nil
      userfrom.name=user.name
    else
      userfrom.name="无名"
    end
    userfrom.first = user.first.to_f
    userfrom.bpnum = user.bpnum.to_i
    userfrom.undfirst = user.undfirst.to_f
    userfrom.id = user.id
    token = getaccesstoken(selleruser.seller_id)
    img = gethtml('https://api.weixin.qq.com/cgi-bin/user/info?access_token=' + token + '&openid=' + selleruser.openid + '&lang=zh_CN')
    img = JSON.parse(img)
    userfrom.img = img['headimgurl']
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
    render json: params[:callback]+'({"user":' + userfrom.to_json + '})',content_type: "application/javascript"
  end

  def setuserupname
    selleruser = @selleruser[0]
    user=User.find(selleruser.user_id)
    systemls = selleruser.systemlogs.new
    systemls.table = "user"
    systemls.userid = user.id
    systemls.userip = request.remote_ip
    systemls.textout = "您于" + Time.new.strftime("%Y-%m-%d %H:%M:%S") + '把用户名“'
    systemls.textout = systemls.textout + user.name.to_s + '”修改为“' + params[:name] + '”'
    user.name=params[:name]
    user.save
    systemls.save
    render json: params[:callback]+'({"err":"0"})',content_type: "application/javascript"
  end

  def getthreename
    selleruser = @selleruser[0]
    user = ActiveRecord::Base.connection.select_all "SELECT b.id,a.name,b.up_id FROM users a,sellerusers b where a.id=b.user_id and a.id in (select user_id from sellerusers where up_id in (select id from sellerusers where up_id = "+selleruser.id.to_s+"))"
    render json: params[:callback]+'({"user":'+user.to_json+'})',content_type: "application/javascript"
  end

  def getreferralname
    selleruser = @selleruser[0]
    user = ActiveRecord::Base.connection.select_all "SELECT b.id,a.name,b.up_id FROM users a,sellerusers b where a.id=b.user_id and a.id in (select user_id from sellerusers where up_id in (select id from sellerusers where up_id = "+selleruser.id.to_s+" or id = "+selleruser.id.to_s+"))"
    render json: params[:callback]+'({"user":'+user.to_json+'})',content_type: "application/javascript"
  end

  def getsenondname
    selleruser = @selleruser[0]
    user = ActiveRecord::Base.connection.select_all "SELECT b.id,a.name,b.up_id FROM users a,sellerusers b where a.id=b.user_id and a.id in (select user_id from sellerusers where up_id in (select id from sellerusers where id = "+selleruser.id.to_s+"))"
    render json: params[:callback]+'({"user":'+user.to_json+'})',content_type: "application/javascript"
  end

  def getwxpublicqrcode
    selleruser = @selleruser[0]
    sid=Seller.find(selleruser.seller_id)
    redirect_to 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=' + sid.appid + '&redirect_uri=http%3a%2f%2fthreeadmin.posan.biz%2fapis%2fgetwxpubliopenid&response_type=code&scope=snsapi_base&state=' + selleruser.id.to_s + '#wechat_redirect'
  end

  def getwxpubliopenid
    selleruser = Selleruser.where("id = ?",params[:state])
    if selleruser.length > 0
      seller = Seller.find(selleruser[0].seller_id)
      openid = getopenid(seller.appid,seller.secret,params[:code])
      sellerfind = Selleruser.where("openid = ? and seller_id = ?",openid,selleruser[0].seller_id)
      if sellerfind.length > 0
        if sellerfind[0].openidposan.to_s == ''
          redirect_to 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=' + $posanappid.to_s + '&redirect_uri=http%3a%2f%2fcoffeeadmin.posan.biz%2fapis%2fthreeopenid&response_type=code&scope=snsapi_base&state=' + sellerfind[0].id.to_s + '#wechat_redirect'
        else
          redirect_to "http://threefront.posan.biz?openid=" + openid.to_s + "&sid=" + selleruser[0].seller_id.to_s
        end
      else
        sellernew=Selleruser.new
        sellernew.repeatshop = 0
        sellernew.openid = openid

        sellernew.up_id = selleruser[0].id
        sellernew.seller_id = seller.id

        token = getaccesstoken(selleruser[0].seller_id)

        img = gethtml('https://api.weixin.qq.com/cgi-bin/user/info?access_token=' + token + '&openid=' + openid + '&lang=zh_CN')
        img = JSON.parse(img)

        user=User.new
        if img['nickname'] == nil
          user.name = "无名"
        else
          user.name=img['nickname']
        end
        user.name=img['nickname']
        user.third=0
        user.senond=0
        user.first=0
        user.undthird=0
        user.undsenond=0
        user.undfirst=0
        user.save
        sellernew.user_id=user.id
        sellernew.save

        modelout(selleruser[0].seller_id,2,selleruser[0].openid,user.id)

        #postcustomtext(token,selleruser[0].openid,"恭喜您，有一人通过扫描您的二维码关注了“" + seller.name.to_s + '”')
        #redirect_to "http://threefront.posan.biz/v-0.9.0-zh_CN-/threesales/main.w?openid=" + openid.to_s + "&sid=" + selleruser[0].seller_id.to_s #发布模式
        redirect_to 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=' + @posanappid + '&redirect_uri=http%3a%2f%2fcoffeeadmin.posan.biz%2fapis%2fthreeopenid&response_type=code&scope=snsapi_base&state=' + selleruser[0].id.to_s + '#wechat_redirect'
        #redirect_to "http://192.168.0.200:8080/x5/UI2/v_/threesales/main.w?openid=" + openid.to_s  #测试模式
      end
    else
      render json: params[:callback]+'({"err":"404"})',content_type: "application/javascript"
    end
  end

  def getwxposanopenid
    selleruser = Selleruser.find(params[:state])
    selleruser.openidposan = params[:openid]
    selleruser.save
    redirect_to "http://threefront.posan.biz/v-0.9.0-zh_CN-/threesales/index.w?openid=" + selleruser.openid.to_s + "&sid=" + selleruser.seller_id.to_s #发布模式
  end

  def getsellerqrcode
    selleruser = @selleruser[0]
    seller=Seller.find(selleruser.seller_id)
    render json: params[:callback]+'({"ticket":"' + seller.qrcode.url + '","name":"' + seller.name + '","err":"正确"})',content_type: "application/javascript"
  end

  def getuserpswds
    selleruser = @selleruser[0]
    user=Userpwd.where('user_id = ?', selleruser.user_id)
    if user.length > 0
      render json: params[:callback]+'({"name":"1","err":"正确"})',content_type: "application/javascript"
    else
      render json: params[:callback]+'({"err":"错误"})',content_type: "application/javascript"
    end
  end
  def setuserpswds
    selleruser = @selleruser[0]
    user=Userpwd.where('user_id = ?', selleruser.user_id)
    if user.length > 0
      user = user[0]
      if user.authenticate(params[:ypwd]) == false
        render json: params[:callback]+'({"err":"错误"})',content_type: "application/javascript"
      else
        user.password = params[:pwd]
        ak = UUIDTools::UUID.timestamp_create.to_s#.gsub('-','')
        user.ak = ak[0,8]
        user.save
        systemls = selleruser.systemlogs.new
        systemls.table = "user"
        systemls.userid = user.id
        systemls.userip = request.remote_ip
        systemls.textout = "您于" + Time.new.strftime("%Y-%m-%d %H:%M:%S") + "修改了提现密码。"
        systemls.save
        render json: params[:callback]+'({"err":"正确","ak":"' + user.ak.to_s + '"})',content_type: "application/javascript"
      end
    else
      user = Userpwd.new
      user.password=params[:pwd]
      #user.password_confirmation = params[:pwd]
      ak = UUIDTools::UUID.timestamp_create.to_s#.gsub('-','')
      user.ak = ak[0,8]
      user.user_id = selleruser.user_id
      user.save
      systemls = selleruser.systemlogs.new
      systemls.table = "user"
      systemls.userid = user.id
      systemls.userip = request.remote_ip
      systemls.textout = "您于" + Time.new.strftime("%Y-%m-%d %H:%M:%S") + "创建了提现密码。"
      systemls.save
      render json: params[:callback]+'({"err":"正确","ak":"' + user.ak.to_s + '"})',content_type: "application/javascript"
    end
  end

  def getak
    selleruser = @selleruser[0]
    user=Userpwd.where('user_id = ?', selleruser.user_id)
    if user.length > 0
      user = user[0]
      if user.authenticate(params[:pwd]) == false
        render json: params[:callback]+'({"err":"错误"})',content_type: "application/javascript"
      else
        ak = UUIDTools::UUID.timestamp_create.to_s#.gsub('-','')
        user.ak = ak[0,8]
        user.save
        render json: params[:callback] + '({"ak":"' + user.ak.to_s + '","err":"正确"})',content_type: "application/javascript"
      end
    else
      render json: params[:callback]+'({"err":"错误"})',content_type: "application/javascript"
    end
  end

  class Systemlogclass
    attr :id,true
    attr :text,true
  end

  def getsystemlog
    selleruser = @selleruser[0]
    systemlog = Systemlog.where('selleruser_id = ?',selleruser.id).limit((params[:num].to_i * 5).to_s + ",5")
    systemlogarr = Array.new
    systemlog.each do |sys|
      systemlogcla = Systemlogclass.new
      systemlogcla.id = sys.id
      systemlogcla.text = sys.textout
      systemlogarr.push(systemlogcla)
    end
    render json: params[:callback] + '({"retoforder":' + systemlogarr.to_json + '})',content_type: "application/javascript"
  end

  def getwxgetrich
    selleruser = @selleruser[0]
    nameddr = params[:name]
    userpwd = Userpwd.where('user_id = ?', selleruser.user_id)
    if userpwd.length > 0
      userpwd = userpwd[0]
      if (userpwd.ak == params[:ak]) && (Time.now < (userpwd.updated_at + 1.hour))
        ak = UUIDTools::UUID.timestamp_create.to_s#.gsub('-','')
        userpwd.ak = ak[0,8]
        userpwd.save
        user = User.find(userpwd.user_id)
        money = params[:money].to_f
        if (user.first.to_f >=  money) && (user.first.to_f > 0) && (money > 0)
          user.first = user.first - money
          user.first = sprintf("%.2f",user.first).to_f
          ordernum = "01" + Time.now.strftime('%Y%m%d%H%M%S') + user.id.to_s
          body = {"ordernumber" => ordernum, "name" => nameddr, "openid" => selleruser.openidposan, "withdraw" => money}
          body = posthtml($postthwxpay,body)
          body = JSON.parse(body[9..(body.length-2)].to_s)["result"]["raw"]["xml"]
          if (body["result_code"]=="SUCCESS") && (body["return_msg"] == "")
            user.save
            systemls = selleruser.systemlogs.new
            systemls.table = "user"
            systemls.userid = user.id
            systemls.userip = request.remote_ip
            systemls.textout = "您于" + Time.new.strftime("%Y-%m-%d %H:%M:%S") + "提现了¥" + money.to_s + "元" + "，订单号为" + ordernum.to_s
            systemls.save
            render json: params[:callback] + '({"err":"正确","money":"' + user.first.to_s + '"})',content_type: "application/javascript"
          else
            render json: params[:callback] + '({"err":"错误","err_code_des":"' + body["err_code_des"].to_s + '"})',content_type: "application/javascript"
          end

          ############提现###################

        else
          render json: params[:callback]+'({"err":"错误"})',content_type: "application/javascript"
        end
      else
        render json: params[:callback]+'({"err":"错误"})',content_type: "application/javascript"
      end
    else
      render json: params[:callback]+'({"err":"错误"})',content_type: "application/javascript"
    end
  end

  class CommClass
    attr :id,true
    attr :img,true
    attr :name,true
    attr :content,true
    attr :pubiletime,true
  end

  def getarticles
    article = Article.find(params[:id])
    article.number = article.number.to_i + 1
    article.save
    comment = article.comments.where('fabulous = 1')
    commentarr = Array.new
    comment.each do |comm|
      commcla = CommClass.new
      commcla.id = comm.id
      commcla.img = comm.img
      commcla.name = comm.name
      commcla.content = comm.content
      commcla.pubiletime = comm.pubiletime
      commentarr.push(commcla)
    end
    render json: params[:callback]+'({"article":' + article.to_json + ',"comment":' + commentarr.to_json + '})',content_type: "application/javascript"
  end

  def getarticleopenid
    article = Article.where('id = ?',params[:id])
    if article.length >0
      article = article[0]
      sid=Seller.find(article.seller_id)
      redirect_to 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=' + sid.appid + '&redirect_uri=http%3a%2f%2fthreeadmin.posan.biz%2fapis%2fgetarticlecontent&response_type=code&scope=snsapi_base&state=' + article.id.to_s + '#wechat_redirect'
    else
      render json: params[:callback]+'({"err":"404"})',content_type: "application/javascript"
    end
  end

  def getarticlecontent
    article = Article.find(params[:state])
    seller = Seller.find(article.seller_id)
    openid = getopenid(seller.appid,seller.secret,params[:code])
    redirect_to "http://threefront.posan.biz/v-0.9.0-zh_CN-/threesales/article.w?openid=" + openid.to_s + "&id=" + article.id.to_s
  end

  def setcomment
    article = Article.find(params[:id])
    comment = article.comments.new
    token = getaccesstoken(article.seller_id)
    img = gethtml('https://api.weixin.qq.com/cgi-bin/user/info?access_token=' + token + '&openid=' + params[:openid] + '&lang=zh_CN')
    img = JSON.parse(img)
    comment.img = img['headimgurl']
    comment.name = img['nickname']
    comment.content = params[:content]
    comment.pubiletime = Time.now
    comment.openid = params[:openid]
    comment.save
    render json: params[:callback]+'({"err":"正确"})',content_type: "application/javascript"
  end

  def getretcauses
    ret = Retcause.all.order('num asc')
    render json: params[:callback]+'({"retcause":' + ret.to_json + '})',content_type: "application/javascript"
  end
  def getbuycardel
    @selleruser = @selleruser[0]
    buycar = Buycar.where("selleruser_id = ? and id = ?",@selleruser.id,params[:id])
    buycar = buycar[0]
    if buycar.deltype == 2
      buycar.deltype = 6
    else
      buycar.deltype = 4
    end
    buycar.save
    render json: params[:callback]+'({"err":"正确"})',content_type: "application/javascript"
  end

end
