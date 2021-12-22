# Links

- https://github.com/rgeo/activerecord-postgis-adapter
- https://tegola.io/documentation/ für Background Tiles
- https://github.com/urbica/martin für Data Overlay Tiles


# Setup einmalig im entryscript

- bundle exec rake db:gis:setup


# Bespiel Datensatz

- lat: 52.546762, lng: 13.454414
- geo = GeoLocation.new
- geo.latitude = 52.546762
- geo.longitude = 13.454414
- geo.save
- x=35217, y=21484, z=16
- http://tile-server.smart-village.docker.localhost:5000/public.geo_locations/z/x/y.pbf
- http://tile-server.smart-village.docker.localhost:5000/public.geo_locations/16/35217/21484.pbf
- http://tile-server.smart-village.docker.localhost:5000/public.geo_locations/18/140869/85939.pbf
