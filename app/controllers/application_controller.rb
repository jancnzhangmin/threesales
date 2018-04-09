class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  require 'net/http'
  def gethtml(http)
    uri = http
    ret=''
    open(uri) do |http|
      ret=http.read
    end
    return ret
  end
  def posthtml(http,body)
    uri = URI.parse(http)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = body
    response = https.request(request)
    return response.body
  end
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
    uri = 'https://api.weixin.qq.com/sns/oauth2/access_token?appid=' + appid + '&secret=' + secret + '&code=' + code + '&grant_type=authorization_code'
    open(uri) do |http|
      htmlresponse=JSON.parse(http.read)
      openid=htmlresponse["openid"]
    end
    return openid
  end
  def delmenu(id)
    token=getaccesstoken(id)
    uri = 'https://api.weixin.qq.com/cgi-bin/menu/delete?access_token='+token
    errmsg='err'
    open(uri) do |http|
      htmlresponse=JSON.parse(http.read)
      errmsg=htmlresponse["errmsg"]
    end
    return errmsg
  end
  def createmenu(id,button)
    token=getaccesstoken(id)
    uri = URI.parse("https://api.weixin.qq.com/cgi-bin/menu/create?access_token=" + token)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = button
    response = https.request(request)
    return response.body
  end
  def gettype(id)
    if id == 1
      return 'click'
    end
    if id == 2
      return 'view'
    end
    if id == 3
      return 'miniprogram'
    end
    if id == 20
      return 'view'
    end
  end
  def geturl(id,url,sid)
    sid=Seller.find(sid)
    url = url.to_s
    if (url.include? 'https://') != true
      if (url.include? 'http://') != true
        url= 'https://' + url
      end
    end
    if id == 2
      return url
    end
    if id == 20
      return 'https://open.weixin.qq.com/connect/oauth2/authorize?appid=' + sid.appid + '&redirect_uri=http%3a%2f%2fthreeadmin.posan.biz%2fapis%2fgetwxopenid&response_type=code&scope=snsapi_base&state=' + sid.id.to_s + '#wechat_redirect'
    end
  end
  def modelout(sellerid,stype,openid,mid)
    sell = Seller.find(sellerid)
    token = getaccesstoken(sell.id)
    case stype
      when 1 #关注通知
        postcustomtext(token,openid,"恭喜您，已成功关注“" + sell.name.to_s + '”')
      when 2..10 #关注后上级通知
        models = sell.sellermodels.where('stype = ?',stype)
        models.each do |model|
          str = '{"touser":"' + openid + '","template_id":"' + model.modeid + '", "data":{ '
          conts = model.modelconts
          table = ActiveRecord::Base.connection.select_all "select * from " + model.tablename + " where id = " + mid.to_s
          table = table[0]
          conts.each do |cont|
            str = str + '"' + cont.wxname + '":{"value":"'
            if cont.stype == 1
              str = str + cont.content + '"},'
            else
              str = str + table[cont.tbname].to_s + '"},'
            end
          end
          str = str[0..(str.length - 2)] + '}}'
          posthtml('https://api.weixin.qq.com/cgi-bin/message/template/send?access_token=' + token,str)
        end
      else
        puts "adult"
    end
  end
end
