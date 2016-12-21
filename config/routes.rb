# frozen_string_literal: true
Rails.application.routes.draw do

  root to: 'home#index'

  devise_for :users, controllers: {
    sessions: 'sessions'
  }

  get '/privacy',     to: 'home#privacy'
  get '/end_user_agreement', to: 'home#end_user_agreement'

  get '/dashboard', to: 'users#show'

  resources :companies, only: [] do
    resources :invoices, only: [:show, :index]
  end

  # Translation
  post 'translattions/:customer_id', to: 'translation_customers#create', as: :create_customer_translation
  put  'translattions/:customer_id', to: 'translation_customers#update', as: :edit_customer_translation

  get 'quickbooks_oauth/authenticate',   to: 'quickbooks_oauth#authenticate'
  get 'quickbooks_oauth/oauth_callback', to: 'quickbooks_oauth#oauth_callback'
  get 'quickbooks_oauth/bluedot',        to: 'quickbooks_oauth#bluedot'
end
