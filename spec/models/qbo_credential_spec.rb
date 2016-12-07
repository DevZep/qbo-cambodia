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

require 'rails_helper'

RSpec.describe QboCredential, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
