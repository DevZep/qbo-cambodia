# == Route Map
#
#                          Prefix Verb   URI Pattern                                Controller#Action
#                            root GET    /                                          home#index
#                new_user_session GET    /users/sign_in(.:format)                   devise/sessions#new
#                    user_session POST   /users/sign_in(.:format)                   devise/sessions#create
#            destroy_user_session DELETE /users/sign_out(.:format)                  devise/sessions#destroy
#                   user_password POST   /users/password(.:format)                  devise/passwords#create
#               new_user_password GET    /users/password/new(.:format)              devise/passwords#new
#              edit_user_password GET    /users/password/edit(.:format)             devise/passwords#edit
#                                 PATCH  /users/password(.:format)                  devise/passwords#update
#                                 PUT    /users/password(.:format)                  devise/passwords#update
#        cancel_user_registration GET    /users/cancel(.:format)                    devise/registrations#cancel
#               user_registration POST   /users(.:format)                           devise/registrations#create
#           new_user_registration GET    /users/sign_up(.:format)                   devise/registrations#new
#          edit_user_registration GET    /users/edit(.:format)                      devise/registrations#edit
#                                 PATCH  /users(.:format)                           devise/registrations#update
#                                 PUT    /users(.:format)                           devise/registrations#update
#                                 DELETE /users(.:format)                           devise/registrations#destroy
#                            user GET    /users/:id(.:format)                       users#show
#   quickbooks_oauth_authenticate GET    /quickbooks_oauth/authenticate(.:format)   quickbooks_oauth#authenticate
# quickbooks_oauth_oauth_callback GET    /quickbooks_oauth/oauth_callback(.:format) quickbooks_oauth#oauth_callback
#        quickbooks_oauth_bluedot GET    /quickbooks_oauth/bluedot(.:format)        quickbooks_oauth#bluedot
#

# frozen_string_literal: true
Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  devise_for :users

  resources :users, only: [:show]

  get 'quickbooks_oauth/authenticate',   to: 'quickbooks_oauth#authenticate'
  get 'quickbooks_oauth/oauth_callback', to: 'quickbooks_oauth#oauth_callback'
  get 'quickbooks_oauth/bluedot',        to: 'quickbooks_oauth#bluedot'
end
