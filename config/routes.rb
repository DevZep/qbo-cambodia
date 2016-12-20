# frozen_string_literal: true
Rails.application.routes.draw do

  root to: 'home#index'

  devise_for :users

  get '/privacy',     to: 'home#privacy'
  get '/term_of_use', to: 'home#term_of_use'

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
