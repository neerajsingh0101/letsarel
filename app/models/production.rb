class Production < ActiveRecord::Base
  belongs_to :movie
  belongs_to :production_house
end
