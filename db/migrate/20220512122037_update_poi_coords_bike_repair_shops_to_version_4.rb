class UpdatePoiCoordsBikeRepairShopsToVersion4 < ActiveRecord::Migration[5.2]
  def change
    update_view :poi_coords_bike_repair_shops, version: 4, revert_to_version: 3
  end
end
