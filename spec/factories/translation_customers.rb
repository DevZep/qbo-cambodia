# == Schema Information
#
# Table name: translation_customers
#
#  billing_address :string
#  company_id      :string
#  created_at      :datetime         not null
#  id              :integer          not null, primary key
#  language_code   :string           default("km")
#  name            :string
#  qbo_customer_id :integer
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_company_id_customers_id_and_code  (company_id,qbo_customer_id,language_code) UNIQUE
#

FactoryGirl.define do
  factory :translation_customer, class: 'Translation::Customer' do
    qbo_customer_id 1
    language_code "MyString"
    name "MyString"
    invoicing_address "MyString"
  end
end
