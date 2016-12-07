class CreateQboCredentials < ActiveRecord::Migration[5.0]
  def change
    create_table :qbo_credentials do |t|
      t.string :access_token
      t.string :access_secret
      t.string :company_id
      t.datetime :token_expires_at
      t.datetime :reconnect_token_at
      t.references :user

      t.timestamps
    end
  end
end
