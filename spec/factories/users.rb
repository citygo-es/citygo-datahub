# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { "test@bbnavi.de" }
    password { "Aute-quis-laborum-euelitsint" }
  end

  factory :admin, class: 'User' do
    email { "admin@smart-village.app" }
    password { "Aute-admin-laborum-euelitsint" }
    role { 1 }
  end
end

# == Schema Information
#
# Table name: users
#
#  id                              :bigint           not null, primary key
#  email                           :string           default(""), not null
#  encrypted_password              :string           default(""), not null
#  reset_password_token            :string
#  reset_password_sent_at          :datetime
#  remember_created_at             :datetime
#  sign_in_count                   :integer          default(0), not null
#  current_sign_in_at              :datetime
#  last_sign_in_at                 :datetime
#  current_sign_in_ip              :string
#  last_sign_in_ip                 :string
#  confirmation_token              :string
#  confirmed_at                    :datetime
#  confirmation_sent_at            :datetime
#  unconfirmed_email               :string
#  failed_attempts                 :integer          default(0), not null
#  unlock_token                    :string
#  locked_at                       :datetime
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  data_provider_id                :integer
#  role                            :integer          default("user")
#  authentication_token            :text
#  authentication_token_created_at :datetime
#
