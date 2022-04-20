# frozen_string_literal: true

require "rails_helper"

RSpec.describe AppUserContent, type: :model do
  it { is_expected.to validate_presence_of(:content) }
  it { is_expected.to validate_presence_of(:data_type) }
  it { is_expected.to validate_presence_of(:data_source) }
end

# == Schema Information
#
# Table name: app_user_contents
#
#  id          :bigint           not null, primary key
#  content     :text
#  data_type   :string
#  data_source :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
