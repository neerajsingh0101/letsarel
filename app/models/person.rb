class Person < ActiveRecord::Base
  attr_accessible :first_name, :last_name

  has_many :collaborations
  has_many :movies, through: :collaborations
  has_many :ordered_movies, through: :collaborations, source: :movie, class_name: 'Movie', order: :title

  def production_houses
    ProductionHouse.
      joins(productions: { movie: :collaborations }).
      merge(collaborations.scoped) 
  end

  def movies_as_actor
    Movie.joins(collaborations: :person).
      merge(Collaboration.as_actor).
      merge(movies.scoped)
  end

  def self.by_name(query)
    q = "%#{ query }%"

    where arel_table[:first_name].matches(q).
            or(arel_table[:last_name].matches(q))
  end
end
