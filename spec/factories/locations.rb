FactoryBot.define do
  factory :location do
    name { "MyString" }
    department { "MyString" }
    district { "MyString" }
    region { "MyString" }
    state { "MyString" }
    country { "MyString" }
  end
end

# == Schema Information
#
# Table name: locations
#
#  id              :bigint           not null, primary key
#  name            :string
#  department      :string
#  district        :string
#  state           :string
#  country         :string
#  locateable_type :string
#  locateable_id   :bigint
#  region_id       :bigint
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
