Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :users, only: [:edit, :update]
  resources :messages
  resources :legislators, only: :index
  root 'static#index', as: :home
end
