class CreateDisciplines < ActiveRecord::Migration
    def change
        create_table :disciplines do |t|

            t.string :name # ex: 100m
            t.string :age_group # ex: m17

            t.boolean :is_male
            t.boolean :is_indoor
        end
    end
end
