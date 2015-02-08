require 'rails_helper'

describe Athlete, :type => :model do

    before :each do
        @result = Athlete.new
    end

    describe '#new' do
        it 'returns a new athlete object' do
            expect(@result).to be_an_instance_of Athlete
        end
    end
end