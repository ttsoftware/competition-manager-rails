class CreateCompetitions < ActiveRecord::Migration
    def change
        create_table :competitions do |t|

            t.string :name
            t.datetime :start_date
            t.datetime :end_date

            t.integer :competition_statletik_id
        end
    end
end
