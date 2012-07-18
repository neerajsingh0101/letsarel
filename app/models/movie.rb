class Movie < ActiveRecord::Base
  attr_accessible :budget, :genre, :released_on, :revenue, :title

  belongs_to :distributor
  has_many :collaborations, dependent: :destroy
  has_many :people, through: :collaborations

  has_many :productions, dependent: :destroy
  has_many :production_houses, through: :productions

  scope :drama,     lambda { where(genre: 'drama') }
  scope :superhero, lambda { where(genre: 'superhero') }

  scope :dccomics, lambda { joins(:production_houses).merge(ProductionHouse.dccomics) }
end
