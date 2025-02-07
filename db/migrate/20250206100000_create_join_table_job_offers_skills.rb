class CreateJoinTableJobOffersSkills < ActiveRecord::Migration[6.0]
  def change
    create_join_table :t_job_offers, :t_skills do |t|
      t.index :t_job_offer_id
      t.index :t_skill_id
    end
  end
end
