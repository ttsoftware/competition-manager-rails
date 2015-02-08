class CreateAthletes < ActiveRecord::Migration
    def change
        create_table :athletes do |t|

            t.string :name
            t.integer :birth_year
            t.boolean :is_group

            t.belongs_to :association, index: true
        end
    end
end
