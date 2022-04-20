# frozen_string_literal: true

FactoryBot.define do
  factory :app_user_content do
    id { 1 }
    content { "MyText" }
    data_type { "MyString" }
    data_source { "MyString" }
  end
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
