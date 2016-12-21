class AddConfirmableToDevise < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_index :users, :confirmation_token, unique: true

    User.update_all(confirmed_at: Time.now) if User.attribute_names.include?('confirmed_at')
  end
end
