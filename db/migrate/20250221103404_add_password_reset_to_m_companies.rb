class AddPasswordResetToMCompanies < ActiveRecord::Migration[8.0]
  def change
    add_column :m_companies, :reset_digest, :string
    add_column :m_companies, :reset_sent_at, :datetime
  end
end
