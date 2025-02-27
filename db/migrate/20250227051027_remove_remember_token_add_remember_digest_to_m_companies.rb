class RemoveRememberTokenAddRememberDigestToMCompanies < ActiveRecord::Migration[6.0]
  def change
    remove_column :m_companies, :remember_token, :string # Remove the remember_token column
    add_column :m_companies, :remember_digest, :string # Add the remember_digest column
  end
end
