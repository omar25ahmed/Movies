class CreateCountriesMoviesJoinTable < ActiveRecord::Migration[7.0]
  def change
    create_join_table :countries, :movies
  end
end
