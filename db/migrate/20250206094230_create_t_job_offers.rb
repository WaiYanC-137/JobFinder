class CreateTJobOffers < ActiveRecord::Migration[6.0]
  def change
    create_table :t_job_offers do |t|
      t.decimal :minsalary, precision: 10, scale: 2  # Example: 99999999.99
      t.decimal :maxsalary, precision: 10, scale: 2  # Example: 99999999.99
      t.references :location, null: false, foreign_key: { to_table: :t_locations }
      t.references :category, null: false, foreign_key: { to_table: :t_categories }
      t.text :description

      t.timestamps
    end
  end
end
