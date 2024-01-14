class CreateFilmingLocationsMoviesJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :filming_locations, :movies
  end
end
