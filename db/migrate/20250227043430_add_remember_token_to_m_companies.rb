class AddRememberTokenToMCompanies < ActiveRecord::Migration[8.0]
  def change
    add_column :m_companies, :remember_token, :string
  end
end
