# frozen_string_literal: true

class Notification::Device < ApplicationRecord
  enum device_type: { undefined: 0, ios: 1, android: 2 }
  has_many :waste_registrations, class_name: "Waste::DeviceRegistration", primary_key: "token", foreign_key: "notification_device_token"

  include Sortable
  sortable_on :device_type, :token

  include Searchable
  searchable_on :token

  # Zusätzlich zu der Validierung hier existiert auch ein unique Index auf das Feld 'token'
  validates_uniqueness_of :token, on: :create, message: "must be unique"
  validates_presence_of :token, on: :create, message: "can't be blank"
end

# == Schema Information
#
# Table name: notification_devices
#
#  id          :bigint           not null, primary key
#  token       :string
#  device_type :integer          default("undefined")
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
