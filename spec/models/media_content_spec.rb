# frozen_string_literal: true

require "rails_helper"

RSpec.describe MediaContent, type: :model do
  it { is_expected.to belong_to(:mediaable) }
  it { is_expected.to have_one(:source_url) }
  it { is_expected.to validate_presence_of(:content_type) }
end

# == Schema Information
#
# Table name: media_contents
#
#  id             :bigint           not null, primary key
#  caption_text   :text
#  copyright      :string
#  height         :string
#  width          :string
#  content_type   :string
#  mediaable_type :string
#  mediaable_id   :bigint
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
