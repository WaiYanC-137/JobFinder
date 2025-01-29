class CreateMCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :m_companies do |t|
      t.string :name
      t.string :email, null: false, unique: true
      t.string :phone
      t.string :password_digest
      t.references :location, foreign_key: { to_table: :t_locations }
      t.text :info
      t.string :address
      t.string :logo

      t.timestamps
    end
  end
end
