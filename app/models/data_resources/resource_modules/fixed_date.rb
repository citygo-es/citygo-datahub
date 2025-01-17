# frozen_string_literal: true

# provides dates to other resources (e.g. Events) who need a fixed dates
class FixedDate < ApplicationRecord
  belongs_to :dateable, polymorphic: true
end

# == Schema Information
#
# Table name: fixed_dates
#
#  id                        :bigint           not null, primary key
#  date_start                :date
#  date_end                  :date
#  weekday                   :string
#  time_start                :time
#  time_end                  :time
#  time_description          :text
#  use_only_time_description :boolean          default(FALSE)
#  dateable_type             :string
#  dateable_id               :bigint
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
