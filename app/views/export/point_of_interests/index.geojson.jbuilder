json.type "FeatureCollection"
json.features do
  json.array! @entries.map(&:to_geojson)
end
