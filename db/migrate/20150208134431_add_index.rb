class AddIndex < ActiveRecord::Migration
    def change

        add_index :results, [
                              :value,
                              :wind,
                              :athlete_id,
                              :competition_id,
                              :discipline_id
                          ],
                  :unique => true,
                  :name => 'athlete_result'
    end
end
