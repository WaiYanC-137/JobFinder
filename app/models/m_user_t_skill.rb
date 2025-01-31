create_table :m_users_t_skills, id: false do |t|
  t.belongs_to :m_user, index: true
  t.belongs_to :t_skill, index: true
end
