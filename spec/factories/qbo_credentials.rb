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

FactoryGirl.define do
  factory :qbo_credential do
    access_token "MyString"
    access_secret "MyString"
    company_id "MyString"
    token_expires_at "2016-12-07 15:53:29"
    reconnect_token_at "2016-12-07 15:53:29"
    references ""
  end
end
