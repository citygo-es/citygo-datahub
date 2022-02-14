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


12.679978303645 52.505898119383
x 35076
y 21497
z 16

https://tiles.bbnavi.de/public.geo_locations/16/35076/21497.pbf
http://localhost:8080/52.505898119383%2C12.679978303645/-


## Poastgres View für Martin
```
Category.find(15).points_of_interest.joins(location: :geo_location).select(:coords, :id).to_sql
```

```
CREATE OR REPLACE VIEW "poi_coords" AS SELECT "coords", "attractions"."id", "attractions"."name" FROM "attractions" INNER JOIN "locations" ON "locations"."locateable_id" = "attractions"."id" AND "locations"."locateable_type" = 'Attraction' INNER JOIN "geo_locations" ON "geo_locations"."geo_locateable_id" = "locations"."id" AND "geo_locations"."geo_locateable_type" = 'Location' INNER JOIN "data_resource_categories" ON "attractions"."id" = "data_resource_categories"."data_resource_id" WHERE "attractions"."type" IN ('PointOfInterest') AND "data_resource_categories"."category_id" = 15 AND "data_resource_categories"."data_resource_type" = 'PointOfInterest';
```


## Postgres View mit Mapping der Attractions über die Adresses und NICHT über die Location

```
CREATE OR REPLACE VIEW "poi_coords" AS
SELECT geo_locations.coords,
    attractions.id,
    attractions.name
   FROM (((attractions
     JOIN addresses ON (((addresses.addressable_id = attractions.id) AND ((addresses.addressable_type)::text = 'Attraction'::text))))
     JOIN geo_locations ON (((geo_locations.geo_locateable_id = addresses.id) AND ((geo_locations.geo_locateable_type)::text = 'Address'::text))))
     JOIN data_resource_categories ON ((attractions.id = data_resource_categories.data_resource_id)))
  WHERE (((attractions.type)::text = 'PointOfInterest'::text) AND (data_resource_categories.category_id = 15) AND ((data_resource_categories.data_resource_type)::text = 'PointOfInterest'::text));
```
