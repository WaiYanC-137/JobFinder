class RemoveSkillsFromMUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :m_users, :skills, :string
  end
end
