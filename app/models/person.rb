class Person < ActiveRecord::Base
  attr_accessible :first_name, :last_name

  has_many :collaborations
  has_many :movies, through: :collaborations

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
end
