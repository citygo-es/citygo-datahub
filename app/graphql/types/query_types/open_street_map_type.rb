# frozen_string_literal: true

module Types
  class QueryTypes::OpenStreetMapType < Types::BaseObject
    field :id, ID, null: true
    field :parking, String, null: true
    field :capacity, Integer, null: true
    field :capacity_charging, String, null: true
    field :capacity_disabled, String, null: true
    field :surface, String, null: true
    field :fee, String, null: true
    field :website, String, null: true
    field :lit, String, null: true
    field :shelter, String, null: true
    field :utilization, String, null: true
  end
end
