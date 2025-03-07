class AddRestrictedToTJobOffers < ActiveRecord::Migration[8.0]
  def change
    add_column :t_job_offers, :restricted, :boolean
  end
end
