class FixPrecisionInGeoLocations < ActiveRecord::Migration[5.2]
  def change
    change_column :geo_locations, :latitude, :float, precision: 64, scale: 16
    change_column :geo_locations, :longitude, :float, precision: 64, scale: 16
  end
end
