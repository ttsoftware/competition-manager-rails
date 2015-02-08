class CreateResults < ActiveRecord::Migration
    def change
        create_table :results do |t|

            t.string :age_group
            t.string :discipline_name

            t.datetime :date
            t.float :value
            t.float :wind

            # relationships
            t.belongs_to :athlete, index: true
            t.belongs_to :competition, index: true
            t.belongs_to :discipline, index: true
        end
    end
end
