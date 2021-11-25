class CreateSurveyQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :survey_questions do |t|
      t.integer :survey_poll_id
      t.text :title, limit: 16.megabytes - 1

      t.timestamps
    end
  end
end
