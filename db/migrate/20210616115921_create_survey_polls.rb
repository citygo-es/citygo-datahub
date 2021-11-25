class CreateSurveyPolls < ActiveRecord::Migration[5.2]
  def change
    create_table :survey_polls do |t|
      t.text :title, limit: 16.megabytes - 1
      t.text :description, limit: 16.megabytes - 1

      t.timestamps
    end
  end
end
