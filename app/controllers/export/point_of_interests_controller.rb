class Export::PointOfInterestsController < ApplicationController

  before_action :doorkeeper_authorize!, except: [:rideshare_points]
  skip_before_action :verify_authenticity_token

  def index
    @category = Category.find_by(id: params[:category_id]) if params[:category_id].present?

    if @category.present?
      @entries = @category.points_of_interest.visible.joins(location: :geo_location)
    else
      @entries = PointOfInterest.joins(location: :geo_location).visible
    end
  end

  def rideshare_points
    category_ids = Category.find_by(name: "Mitfahrpunkte").descendant_ids
    @rideshare_points = PointOfInterest.visible.joins(:categories).where(categories: { id: category_ids})
  end
end
