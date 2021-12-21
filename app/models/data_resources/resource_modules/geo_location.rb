# frozen_string_literal: true

class GeoLocation < ApplicationRecord
  belongs_to :geo_locateable, polymorphic: true, optional: true

  validates_presence_of :latitude, :longitude
  validates :latitude, :longitude, numericality: true

  before_save :store_postgis_coordinates

  def coordinates
    [longitude, latitude]
  end

  def store_postgis_coordinates
    return unless latitude && longitude

    self.coords = RGeo::Cartesian.factory(srid: 4326).point(longitude, latitude)
  end
end

# == Schema Information
#
# Table name: geo_locations
#
#  id                  :bigint           not null, primary key
#  latitude            :float(53)
#  longitude           :float(53)
#  geo_locateable_type :string(255)
#  geo_locateable_id   :bigint
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
