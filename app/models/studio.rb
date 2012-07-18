class Studio < ActiveRecord::Base
  attr_accessible :name
  has_many :movies

  scope :warner,      lambda { where(name: 'Warner Bors. Pictures')     }
  scope :searchlight, lambda { where(name: 'Fox Searchlight Pictures')  }
  scope :marvel,      lambda { where(name: 'Marvel Entertainment')      }
  scope :spyglass,    lambda { where(name: 'Spyglass Entertainment')    }
end
