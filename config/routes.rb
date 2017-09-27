Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :sellers do
    resources :productclas
    resources :products
    resources :admins
    resources :sellerusers
    resources :buycars

  end

  resources :logistics
  resources :logisticorders


  resources :apis do
    collection do
      get 'getseller'
    end
  end



end
