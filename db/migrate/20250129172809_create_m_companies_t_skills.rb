class CreateMCompaniesTSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :m_companies_t_skills do |t|
      t.references :m_company, foreign_key: { to_table: :m_companies }
      t.references :t_skill, foreign_key: { to_table: :t_skills }

      t.timestamps
    end
  end
end
