class CreateMUsersTSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :m_users_t_skills do |t|
      t.references :m_user, foreign_key: { to_table: :m_users }
      t.references :t_skill, foreign_key: { to_table: :t_skills }

      t.timestamps
    end
  end
end
