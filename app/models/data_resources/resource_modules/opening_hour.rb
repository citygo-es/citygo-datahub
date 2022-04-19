# frozen_string_literal: true

class OpeningHour < ApplicationRecord
  belongs_to :openingable, polymorphic: true
end

# == Schema Information
#
# Table name: opening_hours
#
#  id               :bigint           not null, primary key
#  weekday          :string
#  date_from        :date
#  date_to          :date
#  time_from        :time
#  time_to          :time
#  sort_number      :integer
#  open             :boolean
#  description      :string
#  openingable_type :string
#  openingable_id   :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
