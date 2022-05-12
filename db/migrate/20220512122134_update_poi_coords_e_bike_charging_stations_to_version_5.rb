class UpdatePoiCoordsEBikeChargingStationsToVersion5 < ActiveRecord::Migration[5.2]
  def change
    update_view :poi_coords_e_bike_charging_stations, version: 5, revert_to_version: 4
  end
end
