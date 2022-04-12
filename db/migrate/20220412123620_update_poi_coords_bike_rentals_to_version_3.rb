class UpdatePoiCoordsBikeRentalsToVersion3 < ActiveRecord::Migration[5.2]
  def change
    update_view :poi_coords_bike_rentals, version: 3, revert_to_version: 2
  end
end
