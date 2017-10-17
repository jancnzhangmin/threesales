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

end
