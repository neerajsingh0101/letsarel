class CreateProductionHouses < ActiveRecord::Migration
  def change
    create_table :production_houses do |t|
      t.string :name

      t.timestamps
    end
  end
end
