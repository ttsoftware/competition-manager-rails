class CreateCompetitions < ActiveRecord::Migration
    def change
        create_table :competitions do |t|

            t.string :name
            t.datetime :start_date
            t.datetime :end_date

        end
    end
end
