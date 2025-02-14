class CreateMUsersTJobOffersJoinTable < ActiveRecord::Migration[6.0]
  def change
    create_table :m_users_t_job_offers, id: false do |t|
      t.references :m_user, null: false, foreign_key: true
      t.references :t_job_offer, null: false, foreign_key: true
    end
  end
end
