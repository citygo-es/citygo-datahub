# frozen_string_literal: true

class AppUserContent < ApplicationRecord
  validates_presence_of :content, :data_type, :data_source

  after_create :notify_admin

  private

    def notify_admin
      NotificationMailer.notify_admin(self).deliver_later
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
