# frozen_string_literal: true
Rails.application.routes.draw do
  root to: 'home#index'
  devise_for :users
  get '/dashboard', to: 'users#show'

  resources :companies, only: [] do
    member do
      resources :invoices, only: [] do
        get :show

        collection do
          get :search
          get :index
        end
      end
    end
  end

  get 'quickbooks_oauth/authenticate',   to: 'quickbooks_oauth#authenticate'
  get 'quickbooks_oauth/oauth_callback', to: 'quickbooks_oauth#oauth_callback'
  get 'quickbooks_oauth/bluedot',        to: 'quickbooks_oauth#bluedot'
end
