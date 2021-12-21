class AddCoordsToGeoLocations < ActiveRecord::Migration[5.2]
  def change
    add_column :geo_locations, :coords, :st_point, geographic: false
  end
end
