class AddCompanyNameToQboCredential < ActiveRecord::Migration[5.0]
  def change
    add_column :qbo_credentials, :company_name, :string
  end
end
