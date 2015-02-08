class CreateAssociations < ActiveRecord::Migration
    def change
        create_table :associations do |t|

            t.string :name
        end
    end
end
