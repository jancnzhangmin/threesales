class ApisController < ApplicationController

  def getseller
    seller = Seller.find(params[:sellerid])
    render json: params[:callback]+'({"seller":' + seller.to_json + '})',content_type: "application/javascript"
  end

  class Prolist
    attr :id,true
    attr :productimg,true
  end
  def getproductlist
    productls=Product.all
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
    productnas=Product.find(params[:id])
    productarr = Array.new
    ser=Seller.find(productnas.seller_id)
    pcont= Proname.new
    pcont.id = productnas.id
    pcont.name = ser.name
    pcont.content = productnas.content
    productarr.push(pcont)

    render json: params[:callback]+'({"products":'+productarr.to_json+'})',content_type: "application/javascript"
  end

  def getrecepit
    recepit=Recepitaddre.all      # 隐私保护
    render json: params[:callback]+'({"recepits":'+recepit.to_json+'})',content_type: "application/javascript"
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
      selluser=Selleruser.new()
      selluser.seller_id=sellerid.id
      selluser.save
    buycar=Buycar.new()
    buycar.selleruser_id=selluser.id
    buycar.save
    shulian=0
    zongjia=0.00
    arrercon.each do |ide|
      order=Order.new()
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
    buycar.save
    #buycar = Buycar.new()
    #buycar.sava

    #buycar.orders.create([{ :percent => 0,:object_id => "1" :percent => 1, :object_id => "2"}])

    produ=Product.where("id in (?)",params[:ids].split(','))
    render json: params[:callback]+'({"produ":'+buycar.to_json+'})',content_type: "application/javascript"
  end
end
