# frozen_string_literal: true
class QuickbooksOauthController < ApplicationController
  layout false

  def authenticate
    token = QB_OAUTH_CONSUMER.get_request_token(oauth_callback: quickbooks_oauth_oauth_callback_url)
    session[:qb_request_token] = token
    redirect_to("https://appcenter.intuit.com/Connect/Begin?oauth_token=#{token.token}") and return
  end

  def oauth_callback
    at = session[:qb_request_token].get_access_token(oauth_verifier: params[:oauth_verifier])
    token = at.token
    secret = at.secret
    realm_id = params['realmId']

    credential = current_user.qbo_credentials.find_or_initialize_by(company_id: realm_id)

    credential.assign_attributes(
      access_secret: secret,
      access_token: token,
      reconnect_token_at: 5.months.from_now.utc,
      token_expires_at: 6.months.from_now.utc
    )

    if credential.new_record?
      auth = OAuth::AccessToken.new(QB_OAUTH_CONSUMER, credential.access_token, credential.access_secret)
      service  = Quickbooks::Service::CompanyInfo.new(access_token: auth, realm_id: realm_id)
      response = service.query()
      if response.present?
        company = response.first
        credential.company_name = company.company_name
      end
    end

    credential.save
    # @success = true
    User.find(current_user).update(last_login_company: credential.company_id)
    flash.notice = "You have successfully authenticated from QBO"
  end

  def bluedot
    credential = current_user.qbo_credential
    if credential
      consumer = OAuth::AccessToken.new(QB_OAUTH_CONSUMER, credential.access_token, credential.access_secret)
      response = consumer.request(:get, "https://appcenter.intuit.com/api/v1/Account/AppMenu")
      if response && response.body
        html = response.body
        render(text: html) and return
      end
    end
  end
end
