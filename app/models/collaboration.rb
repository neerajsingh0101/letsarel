class Collaboration < ActiveRecord::Base
  belongs_to :movie
  belongs_to :person

  attr_accessible :paid, :role, :person

  scope :as_director, lambda { where(role: 'director') } 
  scope :as_actor,    lambda { where(role: 'actor') } 
  scope :as_actress,  lambda { where(role: 'actress') } 
  scope :as_producer, lambda { where(role: 'producer') } 
  scope :as_musician, lambda { where(role: 'music') } 
  scope :as_writer,   lambda { where(role: 'writer') } 
end
