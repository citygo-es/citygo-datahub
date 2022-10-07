# Links

- https://github.com/rgeo/activerecord-postgis-adapter
- https://tegola.io/documentation/ für Background Tiles
- https://github.com/urbica/martin für Data Overlay Tiles


# Setup einmalig im entryscript

- bundle exec rake db:gis:setup


# Bespiel Datensatz

- https://oms.wff.ch/calc.htm
- lat: 52.546762, lng: 13.454414
- geo = GeoLocation.new
- geo.latitude = 52.546762
- geo.longitude = 13.454414
- geo.save
- x=35217, y=21484, z=16
- http://tile-server.smart-village.docker.localhost:5000/public.geo_locations/z/x/y.pbf
- http://tile-server.smart-village.docker.localhost:5000/public.geo_locations/16/35217/21484.pbf
- http://tile-server.smart-village.docker.localhost:5000/public.geo_locations/18/140869/85939.pbf
- https://tiles.bbnavi.de/index.json
- https://tiles.bbnavi.de/public.geo_locations/10/550/340.pbf
- https://tiles.bbnavi.de/public.poi_coords/10/550/340.pbf
- https://tiles.bbnavi.localhost/public.poi_coords/10/550/340.pbf
- https://tiles.bbnavi.localhost/public.poi_coords_for_category/10/550/340.pbf


12.679978303645 52.505898119383
x 35076
y 21497
z 16

https://tiles.bbnavi.de/public.geo_locations/16/35076/21497.pbf
http://localhost:8080/52.505898119383%2C12.679978303645/-


## Poastgres View für Martin
```
Category.find(15).points_of_interest.joins(addresses: :geo_location).select(:coords, :id).to_sql
```

```
CREATE OR REPLACE VIEW poi_coords" AS SELECT "coords", "attractions"."id", "attractions"."name" FROM "attractions" INNER JOIN "locations" ON "locations"."locateable_id" = "attractions"."id" AND "locations"."locateable_type" = 'Attraction' INNER JOIN "geo_locations" ON "geo_locations"."geo_locateable_id" = "locations"."id" AND "geo_locations"."geo_locateable_type" = 'Location' INNER JOIN "data_resource_categories" ON "attractions"."id" = "data_resource_categories"."data_resource_id" WHERE "attractions"."type" IN ('PointOfInterest') AND "data_resource_categories"."category_id" = 15 AND "data_resource_categories"."data_resource_type" = 'PointOfInterest';
```


## Postgres View mit Mapping der Attractions über die Adresses und NICHT über die Location

```
CREATE OR REPLACE VIEW "poi_coords" AS
SELECT geo_locations.coords,
    attractions.id,
    attractions.name,
    categories.svg_icon
   FROM (((((attractions
     JOIN addresses ON (((addresses.addressable_id = attractions.id) AND ((addresses.addressable_type)::text = 'Attraction'::text))))
     JOIN geo_locations ON (((geo_locations.geo_locateable_id = addresses.id) AND ((geo_locations.geo_locateable_type)::text = 'Address'::text))))
     JOIN data_resource_categories data_resource_categories_attractions_join ON (((data_resource_categories_attractions_join.data_resource_id = attractions.id) AND ((data_resource_categories_attractions_join.data_resource_type)::text = 'PointOfInterest'::text))))
     JOIN categories ON ((categories.id = data_resource_categories_attractions_join.category_id)))
     JOIN data_resource_categories ON ((attractions.id = data_resource_categories.data_resource_id)))
  WHERE attractions.type::text = 'PointOfInterest'::text AND data_resource_categories.category_id = 15 AND data_resource_categories.data_resource_type::text = 'PointOfInterest'::text AND tags.name::text = 'Werkstatt / Reparatur'::text;
```

erstellt aus:

```
Category.find(15).points_of_interest.joins(location: :geo_location, categories: {}).select(:coords, :id, :category).to_sql
```




```
DROP FUNCTION public.poi_coords_for_category(integer,integer,integer,json);
CREATE OR REPLACE FUNCTION public.poi_coords_for_category(z integer, x integer, y integer, query_params json)
  RETURNS bytea AS $$
DECLARE
  mvt bytea;
BEGIN
  SELECT INTO mvt ST_AsMVT(tile, 'public.poi_coords_for_category', 4096, 'coords') FROM (
    SELECT
      ST_AsMVTGeom(ST_Transform(ST_CurveToLine(coords), 3857), TileBBox(z, x, y, 3857), 4096, 64, true) AS coords,
      name,
    FROM public.poi_coords
    WHERE coords && TileBBox(z, x, y, 4326)
  ) as tile WHERE coords IS NOT NULL;

  RETURN mvt;
END $$ LANGUAGE 'plpgsql';
```


```
 SELECT geo_locations.coords,
    CONCAT('e_bike_charging_stations_', attractions.id) as id,
    attractions.id as datahub_id,
    attractions.name,
    categories.svg_icon,
    tags.name AS tag_name
   FROM attractions
     JOIN taggings ON taggings.taggable_id = attractions.id AND taggings.taggable_type::text = 'Attraction'::text AND taggings.context::text = 'tags'::text
     JOIN tags ON tags.id = taggings.tag_id
     JOIN addresses ON addresses.addressable_id = attractions.id AND addresses.addressable_type::text = 'Attraction'::text
     JOIN geo_locations ON geo_locations.geo_locateable_id = addresses.id AND geo_locations.geo_locateable_type::text = 'Address'::text
     JOIN data_resource_categories data_resource_categories_attractions_join ON data_resource_categories_attractions_join.data_resource_id = attractions.id AND data_resource_categories_attractions_join.data_resource_type::text = 'PointOfInterest'::text
     JOIN categories ON categories.id = data_resource_categories_attractions_join.category_id
     JOIN data_resource_categories ON attractions.id = data_resource_categories.data_resource_id
  WHERE attractions.type::text = 'PointOfInterest'::text AND data_resource_categories.category_id = 15 AND data_resource_categories.data_resource_type::text = 'PointOfInterest'::text AND tags.name::text = 'E-Bike-Aufladestation'::text;
```




mit Parameterübergabe asl Postgresfunction:
```
curl "https://tiles.bbnavi.localhost/rpc/public.poi_coords_for_category/10/550/340.pbf?category_id=15&tag_name=E-Bike-Aufladestation"
```

Implementierung in Postgres:
```
DROP FUNCTION public.poi_coords_for_category(integer,integer,integer,json);
CREATE OR REPLACE FUNCTION public.poi_coords_for_category(z integer, x integer, y integer, query_params json)
  RETURNS bytea AS $$
DECLARE
  mvt bytea;
BEGIN
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
    CONCAT(LOWER((query_params ->> 'tag_name')::text), '_', attractions.id) as id,
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
  WHERE attractions.type::text = 'PointOfInterest'::text AND data_resource_categories.category_id = (query_params ->> 'category_id')::integer AND data_resource_categories.data_resource_type::text = 'PointOfInterest'::text AND tags.name::text = (query_params ->> 'tag_name')::text
    ) as foo
    WHERE coords && TileBBox(z, x, y, 4326)
  ) as tile WHERE coords IS NOT NULL;

  RETURN mvt;
END $$ LANGUAGE 'plpgsql';
```



# mit optionalem search Tag:

```
DROP FUNCTION public.poi_coords_for_category(integer,integer,integer,json);
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
```
