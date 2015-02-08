class Competition < ActiveRecord::Base
    has_many :results
    has_many :athletes
    has_and_belongs_to_many :disciplines
end
