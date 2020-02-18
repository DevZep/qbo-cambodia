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
end
