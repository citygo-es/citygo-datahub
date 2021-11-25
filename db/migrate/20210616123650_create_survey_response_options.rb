class CreateSurveyResponseOptions < ActiveRecord::Migration[5.2]
  def change
    create_table :survey_response_options do |t|
      t.integer :survey_question_id
      t.text :title, limit: 16.megabytes - 1
      t.integer :votes_count, default: 0

      t.timestamps
    end
  end
end
