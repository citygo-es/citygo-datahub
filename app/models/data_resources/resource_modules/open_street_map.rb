class OpenStreetMap < ApplicationRecord
end

# == Schema Information
#
# Table name: open_street_maps
#
#  id                :bigint           not null, primary key
#  parking           :string
#  capacity          :integer
#  capacity_charging :string
#  capacity_disabled :string
#  surface           :string
#  fee               :string
#  website           :text
#  lit               :string
#  shelter           :string
#  utilization       :string
#  osm_able_type     :string
#  osm_able_id       :bigint
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
