class CreateCompetitionResults < ActiveRecord::Migration
  def change
    create_table :competition_results do |t|

      t.timestamps null: false
    end
  end
end
