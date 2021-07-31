Rails.application.routes.draw do
  root "couriers#index", as: 'home'

  resources :couriers, expect: [:destroy]
end
