class Result < ActiveRecord::Base
    belongs_to :athlete

    has_one :athlete
    has_one :competition
    has_one :discipline
end
