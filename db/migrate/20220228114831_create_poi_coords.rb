class CreatePoiCoords < ActiveRecord::Migration[5.2]
  def change
    create_view :poi_coords
  end
end
