class CreateWebUrls < ActiveRecord::Migration[5.2]
  def change
    create_table :web_urls do |t|
      t.string :url
      t.string :description
      t.references :web_urlable, polymorphic: true, index: { name: :index_web_urlable }

      t.timestamps
    end
  end
end
