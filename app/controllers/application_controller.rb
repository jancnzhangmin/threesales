class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  require 'net/http'
  def getaccesstoken(id)
    seller=Seller.find(id)
    if seller == nil || seller.appid == nil
      return
    end
    acccardate=seller.access_cardate
    if (seller.access_token == nil) || (seller.access_time ==nil) || (Time.now > (acccardate + (seller.access_time - 30)))
      uri = 'https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid='+seller.appid+'&secret='+seller.secret
      open(uri) do |http|
        htmlresponse=JSON.parse(http.read)
        seller.access_token=htmlresponse["access_token"]
        seller.access_cardate=Time.now
        seller.access_time=htmlresponse["expires_in"]
        seller.save
      end
    end
    return seller.access_token
  end

  def getticket(token,id)
    seller=Selleruser.find(id)
    acccardate=seller.qrcode_cardate
    if (seller.qrcode_ticket ==nil) || (seller.qrcode_cardate == nil) || (Time.now > (acccardate + (seller.qrcodetime.to_i - 30)))
      uri = URI.parse("https://api.weixin.qq.com/cgi-bin/qrcode/create")
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(uri.path+'?access_token='+token)
      request.body = '{"expire_seconds": 86400, "action_name": "QR_SCENE", "action_info": {"scene": {"scene_id": '+id.to_s+'}}}'
      response = https.request(request)
      date=JSON.parse(response.body)
      seller.qrcode_ticket=date["ticket"]
      seller.qrcodetime=date["expire_seconds"]
      seller.qrcode_cardate=Time.now
      seller.qrcode='qrscene_'+id.to_s
      seller.save
    end
    return seller.qrcode_ticket
  end
  def postcustomtext(token,openid,text)
    uri = URI.parse("https://api.weixin.qq.com/cgi-bin/message/custom/send")
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(uri.path+'?access_token='+token)
    request.body = '{"touser":"'+openid.to_s+'","msgtype":"text","text":{"content":"'+text.to_s+'"}}'
    response = https.request(request)

    return response.body
  end
  def getopenid(appid,secret,code)
    openid=nil
    uri = 'https://api.weixin.qq.com/sns/oauth2/access_token?appid='+appid+'&secret='+secret+'&code='+code+'&grant_type=authorization_code'
    open(uri) do |http|
      htmlresponse=JSON.parse(http.read)
      openid=htmlresponse["openid"]
    end
    return openid
  end
end
