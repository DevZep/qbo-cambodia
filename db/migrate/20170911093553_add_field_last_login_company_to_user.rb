class AddFieldLastLoginCompanyToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :last_login_company, :string
  end
end
