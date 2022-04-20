# frozen_string_literal: true

FactoryBot.define do
  factory :region do
    name { "MyString" }
    regionable { nil }
  end
end

# == Schema Information
#
# Table name: regions
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
