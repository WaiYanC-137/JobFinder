class CreateTCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :t_categories do |t|
      t.string :title

      t.timestamps
    end
  end
end
