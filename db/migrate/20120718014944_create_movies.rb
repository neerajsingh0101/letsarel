class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.float :budget
      t.float :revenue
      t.date :released_on
      t.string :genre
      t.references :distributor

      t.timestamps
    end
    add_index :movies, :distributor_id
  end
end
