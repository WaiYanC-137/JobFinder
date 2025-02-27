class AddRememberDigestToMUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :m_users, :remember_digest, :string
  end
end
