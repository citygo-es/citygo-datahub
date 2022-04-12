class UpdatePoiCoordsBikeRepairShopsToVersion3 < ActiveRecord::Migration[5.2]
  def change
    update_view :poi_coords_bike_repair_shops, version: 3, revert_to_version: 2
  end
end
