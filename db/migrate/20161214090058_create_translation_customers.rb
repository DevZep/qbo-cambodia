class CreateTranslationCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :translation_customers do |t|
      t.integer :qbo_customer_id, nil: false
      t.string :language_code, nil: false, default: 'km'
      t.string :name, nil: false
      t.string :billing_address, nil: false

      t.timestamps
    end

    add_index :translation_customers, [:qbo_customer_id, :language_code], unique: true, name: 'index_customers_id_and_code'
  end
end
