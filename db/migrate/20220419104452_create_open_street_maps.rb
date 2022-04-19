class CreateOpenStreetMaps < ActiveRecord::Migration[5.2]
  def change
    create_table :open_street_maps do |t|
      t.string :parking
      t.integer :capacity
      t.string :capacity_charging
      t.string :capacity_disabled
      t.string :surface
      t.string :fee
      t.text :website
      t.string :lit
      t.string :shelter
      t.string :utilization
      t.references :osm_able, polymorphic: true, index: true

      t.timestamps
    end
  end
end
