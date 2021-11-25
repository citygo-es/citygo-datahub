class CreateGeoLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :geo_locations do |t|
      t.float :latitude
      t.float :longitude
      t.references :geo_locateable, polymorphic: true, index: "index_geo_locateable_type_and_id"
      t.timestamps
    end
  end
end
