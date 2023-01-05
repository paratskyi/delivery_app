Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  devise_for :delivery_managers, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root "couriers#index", as: 'root'

  resources :couriers, expect: [:destroy]
  resources :packages, only: [:create]
end
