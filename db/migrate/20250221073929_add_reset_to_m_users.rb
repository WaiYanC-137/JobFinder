class AddResetToMUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :m_users, :reset_digest, :string
    add_column :m_users, :reset_sent_at, :datetime
  end
end
