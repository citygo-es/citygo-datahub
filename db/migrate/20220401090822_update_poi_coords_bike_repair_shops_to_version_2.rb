class UpdatePoiCoordsBikeRepairShopsToVersion2 < ActiveRecord::Migration[5.2]
  def change
    update_view :poi_coords_bike_repair_shops, version: 2, revert_to_version: 1
  end
end