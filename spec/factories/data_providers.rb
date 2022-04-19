FactoryBot.define do
  factory :data_provider do
    name { "MyString" }
    description { "MyString" }
  end
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
