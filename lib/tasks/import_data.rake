require 'csv'

namespace :import_data do
  desc "Bulk import movies and reviews from CSV files"
  task bulk_csv_import_try: :environment do
    casts_data = []
    filming_locations = {}
    countries = {}

    # Process Movies and related data
    CSV.foreach(Rails.root.join('lib', 'seeds', 'movies.csv'), headers: true) do |row|
      movie = Movie.find_or_create_by!(name: row['Movie'], description: row['Description'], year: row['Year'])

      # Process people (directors and actors) and create Casts
      ['Director', 'Actor'].each do |role|
        person_name = row[role]
        next if person_name.blank?

        person = Person.find_or_create_by!(name: person_name)
        casts_data << { movie_id: movie.id, person_id: person.id, role: role.downcase }
      end

      # Process filming locations
      if row['Filming location'].present?
        location = (filming_locations[row['Filming location']] ||= FilmingLocation.find_or_create_by!(name: row['Filming location']))
        movie.filming_locations << location unless movie.filming_locations.include?(location)
      end

      # Process countries
      if row['Country'].present?
        country = (countries[row['Country']] ||= Country.find_or_create_by!(name: row['Country']))
        movie.countries << country unless movie.countries.include?(country)
      end
    end

    # Bulk insert Casts
    Cast.import casts_data.uniq.map { |cd| Cast.new(cd) }

    # Import Reviews
    reviews = []
    CSV.foreach(Rails.root.join('lib', 'seeds', 'reviews.csv'), headers: true) do |row|
      user = User.find_or_create_by!(name: row['User'])
      movie = Movie.find_by(name: row['Movie'])
      reviews << Review.new(movie: movie, user: user, stars: row['Stars'], body: row['Review']) if movie
    end

    Review.import reviews
    puts 'Movies, People, Casts, Filming Locations, Countries, and Reviews imported'
  end
end
