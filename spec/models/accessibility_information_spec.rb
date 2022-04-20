# frozen_string_literal: true

require "rails_helper"

RSpec.describe AccessibilityInformation, type: :model do
  it { is_expected.to belong_to(:accessable) }
end

# == Schema Information
#
# Table name: accessibility_informations
#
#  id              :bigint           not null, primary key
#  description     :text
#  types           :string
#  accessable_type :string
#  accessable_id   :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
