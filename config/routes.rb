Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :sellers do
    resources :productclas


    resources :products

    resources :admins

  end
  resources :apis do
    collection do
      get 'getseller'
    end
  end



end
