# frozen_string_literal: true

require "rails_helper"

RSpec.describe DataProvider, type: :model do
  it { is_expected.to have_one(:address) }
  it { is_expected.to have_one(:contact) }
  it { is_expected.to have_one(:logo) }
end

# == Schema Information
#
# Table name: data_providers
#
#  id              :bigint           not null, primary key
#  name            :string
#  description     :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  always_recreate :text
#  roles           :text
#  data_type       :integer          default("general_importer")
#  notice          :text
#
