Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => 'sellers#index'
  resources :sellers do
    resources :productclas
    resources :products
    resources :admins
    resources :sellerusers
    resources :buycars
    resources :notices
  end

  resources :logistics
  resources :logisticorders

  resources :recepitaddres

  resources :orders
  resources :userpwds
  resources :users

  resources :notices

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
    end

  end

  resources :weixinlogs

end
