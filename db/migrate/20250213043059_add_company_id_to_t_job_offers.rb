class AddCompanyIdToTJobOffers < ActiveRecord::Migration[8.0]
  def change
    add_column :t_job_offers, :company_id, :bigint
  end
end
