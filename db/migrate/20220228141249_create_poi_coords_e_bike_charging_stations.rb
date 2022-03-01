class CreatePoiCoordsEBikeChargingStations < ActiveRecord::Migration[5.2]
  def change
    create_view :poi_coords_e_bike_charging_stations
  end
end
