Rails.application.routes.draw do

  get 'logisticbuycar/update'
  get 'logisticbuycar/destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => 'sellers#index'
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
    end
    resources :notices
    resources :weixinmenus
  end

  resources :logistics
  resources :logisticorders


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
    end
  end

  resources :weixinlogs

end
