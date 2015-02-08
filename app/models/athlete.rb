class Athlete < ActiveRecord::Base
    has_many :results
    has_many :competitions
end