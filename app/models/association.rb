class Association < ActiveRecord::Base
    has_many :athletes
    has_many :results, through: :athletes
end
