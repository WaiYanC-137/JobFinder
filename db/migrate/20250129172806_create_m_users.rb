class CreateMUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :m_users do |t|
      t.string :name
      t.string :email, null: false, unique: true
      t.string :password_digest
      t.text :about
      t.text :skills
      t.string :phone
      t.references :location, foreign_key: { to_table: :t_locations }
      t.references :category, foreign_key: { to_table: :t_categories }
      t.string :profile_picture

      t.timestamps
    end
  end
end
