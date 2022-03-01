class CreatePoiCoordsEBikeRentals < ActiveRecord::Migration[5.2]
  def change
    create_view :poi_coords_e_bike_rentals
  end
end
