class CreatePoiCoordsBikeRepairShops < ActiveRecord::Migration[5.2]
  def change
    create_view :poi_coords_bike_repair_shops
  end
end
