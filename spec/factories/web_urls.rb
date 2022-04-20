FactoryBot.define do
  factory :web_url do
    for_data_provider
    url { "http://www.test.de" }
    description { "MyString" }
    trait :for_data_provider do
      association(:web_urlable, factory: :data_provider)
    end
  end
end

# == Schema Information
#
# Table name: web_urls
#
#  id               :bigint           not null, primary key
#  url              :text
#  description      :text
#  web_urlable_type :string
#  web_urlable_id   :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
