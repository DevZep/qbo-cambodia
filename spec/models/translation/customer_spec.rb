# == Schema Information
#
# Table name: translation_customers
#
#  billing_address :string
#  created_at      :datetime         not null
#  id              :integer          not null, primary key
#  language_code   :string           default("km")
#  name            :string
#  qbo_customer_id :integer
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_customers_id_and_code  (qbo_customer_id,language_code) UNIQUE
#

require 'rails_helper'

RSpec.describe Translation::Customer, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
