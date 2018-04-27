Rails.application.routes.draw do

  root :to => 'login#login'

  post "login/findlogin"
  get "login/login"
  get "login/unlogin"
  resources :systemlogs
  resources :retcauses
  resources :comments
  resources :articles
  resources :admins
  get 'logisticbuycar/update'
  get 'logisticbuycar/destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :sellers do

    resources :productclas

    resources :products

    resources :admins

    resources :sellerusers
    resources :buycars do
      #resources :logisticbuycar
      get 'logisticbuycar/index'
      get 'logisticbuycar/edit'
      get 'logisticbuycar/new'
      collection do
        get 'editstatus'
      end
      resources :retoforders do
        member do
          get 'setretok'
          get 'setretno'
          get 'setlogisticok'
        end
      end
      member do
        post 'setsellererr'
      end
    end
    resources :notices
    resources :weixinmenus
    resources :articles do
      resources :comments do
        member do
          get  'publecomm'
          get  'publedel'
        end
      end
    end
    resources :sellermodels do
      resources :modelconts
    end
  end

  resources :logistics
  resources :logisticorders
  resources :stables

  resources :recepitaddres

  resources :orders
  resources :userpwds
  resources :users

  resources :notices

  resources :weixinmenus do
    collection do
      get 'saveweixin'
      get 'saveid'
      get 'delid'
      get 'loading'
    end
  end

  resources :apis do
    collection do
      get 'getreceoitdefault'
      get 'getseller'
      get 'getproductlist'
      get 'getproductcontent'
      get 'getproname'
      get 'getrecepit'
      get 'getbuycarfrom'
      get 'getbuycarlist'
      get 'getreceoitadd'
      get 'getrecepitone'
      get 'getreceoitedit'
      get 'getreceoitdel'
      get 'getreceoitdefa'
      get 'getnotice'
      post 'weixingetpost'
      get 'weixingetpost'
      get 'getweixinimg'
      get 'getwxopenid'
      get 'getbuycaradd'
      get 'setreceive'
      get 'getbuycarplay'
      get 'getbuycarconfirm'
      get 'getuserupname'
      get 'setuserupname'
      get 'getthreename'
      get 'getsenondname'
      get 'getreferralname'
      get 'getwxpublicqrcode'
      get 'getwxpubliopenid'
      get 'getsellerqrcode'
      get 'getuserpswds'
      get 'setuserpswds'
      get 'getak'
      get 'getwxgetrich'
      get 'getarticles'
      get 'getarticleopenid'
      get 'getarticlecontent'
      get 'setcomment'
      get 'getsystemlog'
      get 'getbuycaraftersales'
      get 'setafterone'
      get 'getlogistics'
      get 'getafterlogistics'
      get 'setlogistics'
      get 'getretcauses'
      get 'getwxposanopenid'
      get 'getbuycardel'
      post 'prepaytrue'
      get 'getbuycartruemoney'
    end
  end

  resources :weixinlogs

end
