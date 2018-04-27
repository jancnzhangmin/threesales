class LoginController < ApplicationController
  def login
    @user = Admin.new
  end
  def findlogin
    user = Admin.find_by(login:params[:admin][:username])
    if user == nil
      redirect_to root_path, notice: '密码或用户名错误！'
    elsif (user.authenticate(params[:admin][:pwd]) == false)
      user.errpwd = user.errpwd.to_i + 1
      if (user.loginnum.to_i != 0) && (Time.now < (user.updated_at + 1.hour))
        user.loginnum = 0
      end
      user.save
      redirect_to root_path, notice: '用户名或密码错误！'
    elsif (user.errpwd.to_i > 4) || (user.nids.to_i > 9) || (user.status != "1")
      redirect_to root_path, notice: '密码错误次数过多或未启用，请联系管理员！'
    else
      if (user.loginnum.to_i != 0) && (Time.now < (user.updated_at + 1.hour))
        redirect_to root_path, notice: '用户已在其他地方登录！'
      else
        if session[:current_user_id] != nil
          yuser = Admin.find(session[:current_user_id])
          yuser.loginnum = 0
          yuser.save
        end
        session[:current_user_id] = user.id
        if user.seller_id == nil
          session[:admin] = "admin"
          session[:role] = user.auth
        else
          session[:role] = user.auth
          session[:admin] = nil
        end
        user.loginnum = 1
        user.errpwd = 0
        user.updated_at = Time.now
        user.save
        redirect_to sellers_path
      end
    end
  end
  def unlogin
    user = Admin.find(session[:current_user_id])
    user.loginnum=0
    user.save
    session[:current_user_id] = nil
    session[:admin] = nil
    session[:role] = nil
    redirect_to root_path, notice: '成功退出登录!'
  end
end
