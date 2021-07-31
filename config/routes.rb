Rails.application.routes.draw do
  root "couriers#index", as: 'root'

  resources :couriers, expect: [:destroy]
  resources :packages, only: [:create]
end
