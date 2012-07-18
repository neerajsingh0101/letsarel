class Distributor < ActiveRecord::Base
  has_many :movies
  attr_accessible :name
  scope :warner, lambda { where(name:  "Warner Bros. Pictures") }
end
