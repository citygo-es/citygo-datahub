# frozen_string_literal: true

FactoryBot.define do
  factory :contact do
    phone { "01234567" }
    fax { "MyString" }
    email { "my.string@test.de" }
    trait :for_operating_company do
      association(:contactable, factory: %i[operating_company for_poi])
    end
  end
end

# == Schema Information
#
# Table name: contacts
#
#  id               :bigint           not null, primary key
#  first_name       :string
#  last_name        :string
#  phone            :string
#  fax              :string
#  email            :string
#  contactable_type :string
#  contactable_id   :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
