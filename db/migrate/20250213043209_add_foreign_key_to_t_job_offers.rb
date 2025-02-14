class AddForeignKeyToTJobOffers < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :t_job_offers, :m_companies, column: :company_id
  end
end
