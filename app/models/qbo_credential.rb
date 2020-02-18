# == Schema Information
#
# Table name: qbo_credentials
#
#  access_secret      :string
#  access_token       :string
#  company_id         :string
#  company_name       :string
#  created_at         :datetime         not null
#  id                 :integer          not null, primary key
#  reconnect_token_at :datetime
#  token_expires_at   :datetime
#  updated_at         :datetime         not null
#  user_id            :integer
#
# Indexes
#
#  index_qbo_credentials_on_user_id  (user_id)
#

class QboCredential < ApplicationRecord
  belongs_to :user

  validates :company_id,
            :oauth2_access_token,
            :oauth2_refresh_token,
            :oauth2_access_token_expires_at,
            :oauth2_refresh_token_expires_at, presence: true

  validates :user, presence: true

  def refresh_tokens
    return if oauth2_access_token_expires_at? && oauth2_access_token_expires_at > Time.current

    oauth_client = IntuitOAuth::Client.new(
      ENV['QBO_CLIENT_ID'],
      ENV['QBO_CLIENT_SECRET'],
      '',
      Rails.env.development? ? 'sandbox' : 'production'
    )

    response = oauth_client.token.refresh_tokens(oauth2_refresh_token)

    self.update(
      oauth2_access_token: response.access_token,
      oauth2_refresh_token: response.refresh_token,
      oauth2_access_token_expires_at: response.expires_in.seconds.from_now,
      oauth2_refresh_token_expires_at: response.x_refresh_token_expires_in.seconds.from_now
    )
  end
end
