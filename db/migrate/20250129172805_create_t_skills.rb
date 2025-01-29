class CreateTSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :t_skills do |t|
      t.string :title

      t.timestamps
    end
  end
end
