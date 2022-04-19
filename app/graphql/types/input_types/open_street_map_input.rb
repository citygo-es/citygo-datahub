# frozen_string_literal: true

module Types
  class InputTypes::OpenStreetMapInput < BaseInputObject
    argument :parking, String, required: false
    argument :capacity, Integer, required: false
    argument :capacity_charging, String, required: false
    argument :capacity_disabled, String, required: false
    argument :surface, String, required: false
    argument :fee, String, required: false
    argument :website, String, required: false
    argument :lit, String, required: false
    argument :shelter, String, required: false
    argument :utilization, String, required: false
  end
end
