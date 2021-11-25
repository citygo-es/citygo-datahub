class CreateSurveyPolls < ActiveRecord::Migration[5.2]
  def change
    create_table :survey_polls do |t|
      t.text :title, limit: 4294967295
      t.text :description, limit: 4294967295

      t.timestamps
    end
  end
end
