class AddOauth2AccessTokenToQboCredentials < ActiveRecord::Migration[5.0]
  def change
    add_column :qbo_credentials,  :oauth2_access_token, :text
    add_column :qbo_credentials,  :oauth2_access_token_expires_at, :datetime
    add_column :qbo_credentials,  :oauth2_refresh_token, :text
    add_column :qbo_credentials,  :oauth2_refresh_token_expires_at, :datetime
  end
end
