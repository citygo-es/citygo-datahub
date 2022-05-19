class CreatePoiCoordsRidesharePoints < ActiveRecord::Migration[5.2]
  def change
    create_view :poi_coords_rideshare_points
  end
end
