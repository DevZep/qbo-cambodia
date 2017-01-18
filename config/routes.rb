# frozen_string_literal: true
Rails.application.routes.draw do

  root to: 'home#index'

  devise_for :users, controllers: {
    sessions: 'sessions'
  }

  get '/privacy',     to: 'home#privacy'
  get '/end_user_agreement', to: 'home#end_user_agreement'

  get '/companies', to: 'companies#index'
  get '/companies/:id', to: 'companies#show', as: :company

  #all debits and all invoices
  get '/companies/:company_id/invoices/debits', to: 'invoices#debit', as: :invoices_debits_path
  get '/companies/:company_id/invoices/invoices', to: 'invoices#invoice', as: :invoices_invoices_path
  get '/companies/:company_id/invoices/need_attention', to: 'invoices#need_attention', as: :invoices_need_attentions

  get '/companies/:company_id/receipt/:id/', to: 'invoices#receipt', as: :invoices_invoices_receipt


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
