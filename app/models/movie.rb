class Movie < ApplicationRecord
  has_many :reviews
  has_many :casts
  has_many :people, through: :casts
  has_and_belongs_to_many :filming_locations
  has_and_belongs_to_many :countries

  scope :by_actor, -> (actor = nil) {
    if actor.present?
      joins(casts: :person)
        .where('people.name ILIKE ? AND casts.role = ?', "%#{actor}%", 'Actor')
        .distinct
    else
      all.limit(50)
    end
  }

  scope :sort_by_revision, -> {
    joins(:reviews).select('movies.*, AVG(reviews.stars) as average_stars')
                           .group('movies.id')
                           .order('average_stars DESC')
  }
end
