Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :users, only: [:edit, :update]
  resources :legislators, only: :index
  resources :messages, only: [:new, :edit, :create]
  root 'static#index', as: :home
end
