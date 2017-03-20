Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: 'registrations'
  }
  resources :users, only: [:edit, :update]
  resources :legislators, only: :index
  resources :messages, only: [:new, :edit, :create]
  get 'messages/address', as: :message_address, defaults: { format: :json }
  root 'messages#new', as: :home
end
