class AddIndexToAttractions < ActiveRecord::Migration[5.2]
  def change
    add_index :attractions, :name
    add_index :attractions, :data_provider_id
    add_index :attractions, :type
    add_index :attractions, :external_id
    add_index :data_resource_categories, [:data_resource_id, :data_resource_type], name: 'index_drc_on_dr_id_and_dr_type'
    add_index :data_resource_categories, :category_id
    add_index :addresses, [:addressable_id, :addressable_type], name: 'index_addresses_on_addressable_id_and_addressable_type'
    add_index :geo_locations, [:geo_locateable_id, :geo_locateable_type], name: 'index_geo_locations_on_locable_id_and_locaable_type'
    add_index :geo_locations, :coords
    add_index :geo_locations, [:latitude, :longitude]
  end
end
