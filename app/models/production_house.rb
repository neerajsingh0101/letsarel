class ProductionHouse < ActiveRecord::Base
  attr_accessible :name
  has_many :productions

  scope :dccomics, lambda { where(name: 'DC Comics') }
end
