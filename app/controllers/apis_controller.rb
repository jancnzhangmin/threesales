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

  class Proname
    attr :id,true
    attr :name,true
    attr :content,true
  end
  def getproductcontent
    productnas=Product.find(params[:id])
    productarr = Array.new
    productnas.each do |pro|
      pcont= Proname.new
      pcont.id = pro.id
      pcont.name = pro.name
      pcont.content = pro.content
    end
    render json: params[:callback]+'({"products":'+productarr.to_json+'})',content_type: "application/javascript"
  end

end
