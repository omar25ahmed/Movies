class Cast < ApplicationRecord
  belongs_to :movie
  belongs_to :person

  # could be extended to more roles
  enum role: { actor: 'Actor', director: 'Director' }
end
