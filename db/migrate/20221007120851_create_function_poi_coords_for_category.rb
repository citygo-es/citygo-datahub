class CreateFunctionPoiCoordsForCategory < ActiveRecord::Migration[5.2]
  def up
    connection.execute(%q(
      CREATE OR REPLACE FUNCTION public.poi_coords_for_category(z integer, x integer, y integer, query_params json)
  RETURNS bytea AS $$
DECLARE
  mvt bytea;
  search_category_id integer := (query_params ->> 'category_id')::integer;
  search_tag text := (query_params ->> 'tag_name')::text;
BEGIN
  IF search_tag > '' THEN
	  SELECT INTO mvt ST_AsMVT(tile, 'public.poi_coords_for_category', 4096, 'coords') FROM (
	    SELECT
	      ST_AsMVTGeom(ST_Transform(ST_CurveToLine(coords), 3857), TileBBox(z, x, y, 3857), 4096, 64, true) AS coords,
	      id,
	      name,
	      tag_name,
	      datahub_id,
	      svg_icon
	    FROM (
	    	SELECT geo_locations.coords,
	    CONCAT(LOWER(search_tag), '_', attractions.id) as id,
	    attractions.id as datahub_id,
	    attractions.name as name,
	    categories.svg_icon as svg_icon,
	    tags.name AS tag_name
	   FROM attractions
	     JOIN taggings ON taggings.taggable_id = attractions.id AND taggings.taggable_type::text = 'Attraction'::text AND taggings.context::text = 'tags'::text
	     JOIN tags ON tags.id = taggings.tag_id
	     JOIN addresses ON addresses.addressable_id = attractions.id AND addresses.addressable_type::text = 'Attraction'::text
	     JOIN geo_locations ON geo_locations.geo_locateable_id = addresses.id AND geo_locations.geo_locateable_type::text = 'Address'::text
	     JOIN data_resource_categories data_resource_categories_attractions_join ON data_resource_categories_attractions_join.data_resource_id = attractions.id AND data_resource_categories_attractions_join.data_resource_type::text = 'PointOfInterest'::text
	     JOIN categories ON categories.id = data_resource_categories_attractions_join.category_id
	     JOIN data_resource_categories ON attractions.id = data_resource_categories.data_resource_id
	  WHERE attractions.type::text = 'PointOfInterest'::text AND data_resource_categories.category_id = search_category_id AND data_resource_categories.data_resource_type::text = 'PointOfInterest'::text AND tags.name::text = search_tag
	    ) as foo
	    WHERE coords && TileBBox(z, x, y, 4326)
	  ) as tile WHERE coords IS NOT NULL;
	ELSE
		SELECT INTO mvt ST_AsMVT(tile, 'public.poi_coords_for_category', 4096, 'coords') FROM (
	    SELECT
	      ST_AsMVTGeom(ST_Transform(ST_CurveToLine(coords), 3857), TileBBox(z, x, y, 3857), 4096, 64, true) AS coords,
	      id,
	      name,
	      datahub_id,
	      svg_icon
	    FROM (
	    	SELECT geo_locations.coords,
	    attractions.id as id,
	    attractions.id as datahub_id,
	    attractions.name as name,
	    categories.svg_icon as svg_icon
	   FROM attractions
	     JOIN addresses ON addresses.addressable_id = attractions.id AND addresses.addressable_type::text = 'Attraction'::text
	     JOIN geo_locations ON geo_locations.geo_locateable_id = addresses.id AND geo_locations.geo_locateable_type::text = 'Address'::text
	     JOIN data_resource_categories data_resource_categories_attractions_join ON data_resource_categories_attractions_join.data_resource_id = attractions.id AND data_resource_categories_attractions_join.data_resource_type::text = 'PointOfInterest'::text
	     JOIN categories ON categories.id = data_resource_categories_attractions_join.category_id
	     JOIN data_resource_categories ON attractions.id = data_resource_categories.data_resource_id
	  WHERE attractions.type::text = 'PointOfInterest'::text AND data_resource_categories.category_id = search_category_id AND data_resource_categories.data_resource_type::text = 'PointOfInterest'::text
	    ) as foo
	    WHERE coords && TileBBox(z, x, y, 4326)
	  ) as tile WHERE coords IS NOT NULL;
	END IF;

  RETURN mvt;
END $$ LANGUAGE 'plpgsql';
    ))
  end

  def down
    connection.execute(%q(
      DROP FUNCTION public.poi_coords_for_category(integer,integer,integer,json);
    ))
  end
end
