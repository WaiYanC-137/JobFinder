class CreateTLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :t_locations do |t|
      t.string :city

      t.timestamps
    end
  end
end
