class Export::PointOfInterestsController < ApplicationController

  # action_cache

  def index
    @entries = PointOfInterest.joins(location: :geo_location).visible
  end
end
