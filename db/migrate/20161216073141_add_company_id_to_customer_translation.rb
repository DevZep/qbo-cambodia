class AddCompanyIdToCustomerTranslation < ActiveRecord::Migration[5.0]
  def change
    Translation::Customer.destroy_all if Translation::Customer.attribute_names.exclude?('company_id')
    add_column :translation_customers, :company_id, :string, nil: false

    remove_index :translation_customers, [:qbo_customer_id, :language_code] if index_exists?(:translation_customers, [:qbo_customer_id, :language_code])
    add_index :translation_customers,
              [:company_id, :qbo_customer_id, :language_code],
              unique: true,
              name: 'index_company_id_customers_id_and_code'
  end
end
