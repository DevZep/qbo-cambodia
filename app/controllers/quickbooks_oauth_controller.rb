# frozen_string_literal: true
class QuickbooksOauthController < ApplicationController
  layout false

  before_action :authorize_state_token, only: :oauth_callback

  def authenticate
    authorizationCodeUrl = oauth_client.code.get_auth_uri([IntuitOAuth::Scopes::ACCOUNTING], ENV['QBO_STATE'])
    redirect_to authorizationCodeUrl
  end

  def oauth_callback
    realm_id = params[:realmId]
    response = oauth_client.token.get_bearer_token(params[:code], realm_id)
    credential = current_user.qbo_credentials.find_or_initialize_by(company_id: realm_id)

    credential.assign_attributes(
      oauth2_access_token: response.access_token,
      oauth2_refresh_token: response.refresh_token,
      oauth2_access_token_expires_at: response.expires_in.seconds.from_now,
      oauth2_refresh_token_expires_at: response.x_refresh_token_expires_in.seconds.from_now
    )

    if credential.new_record?
      access_token = OAuth2::AccessToken.new(QB_OAUTH2, credential.oauth2_access_token, refresh_token: credential.oauth2_refresh_token)
      service  = Quickbooks::Service::CompanyInfo.new(access_token: access_token, realm_id: realm_id)
      response = service.query()

      if response.present?
        company = response.first
        credential.company_name = company.company_name
      end
    end

    credential.save
    current_user.update(last_login_company: credential.company_id)
    flash.notice = "You have successfully authenticated from QBO"
  end

  def bluedot
    credential = current_user.qbo_credential

    if credential
      access_token = OAuth2::AccessToken.new(oauth_client, credential.oauth2_access_token, refresh_token: credential.refresh_token)
      response = access_token.request(:get, "https://appcenter.intuit.com/api/v1/Account/AppMenu")

      if response && response.body
        html = response.body
        render(text: html) and return
      end
    end
  end

  private

  def oauth_client
    @oauth_client ||= IntuitOAuth::Client.new(ENV['QBO_CLIENT_ID'], ENV['QBO_CLIENT_SECRET'], quickbooks_oauth_oauth_callback_url, Rails.env.development? ? 'sandbox' : 'production')
  end

  def authorize_state_token
    return(redirect_to root_path) if params[:state] != ENV['QBO_STATE']
  end
end
