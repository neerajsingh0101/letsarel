class CreateCollaborations < ActiveRecord::Migration
  def change
    create_table :collaborations do |t|
      t.references :movie
      t.references :person
      t.string :role
      t.float :paid

      t.timestamps
    end
    add_index :collaborations, :movie_id
    add_index :collaborations, :person_id
  end
end
