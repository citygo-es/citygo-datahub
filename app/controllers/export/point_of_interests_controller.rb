class Export::PointOfInterestsController < ApplicationController
  after_action :set_headers
  # action_cache

  def index
    @entries = PointOfInterest.joins(location: :geo_location).visible
  end

  def set_headers
    headers["Access-Control-Allow-Origin"] = "*"
    headers["Access-Control-Request-Method"] = %w{GET POST OPTIONS}.join(",")

    # possible X-Frame-Options: https://developer.mozilla.org/de/docs/Web/HTTP/Headers/X-Frame-Options
    # Rails sets "sameorigin" as default, so we need to remove that in order to allow all
    headers.delete "X-Frame-Options"
  end
end
