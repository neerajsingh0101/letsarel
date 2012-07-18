class CreateProductions < ActiveRecord::Migration
  def change
    create_table :productions do |t|
      t.references :movie
      t.references :production_house

      t.timestamps
    end
    add_index :productions, :movie_id
    add_index :productions, :production_house_id
  end
end
