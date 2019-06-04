# frozen_string_literal: true

# this model describes the data for an event e.g. a concert or a reading.
class EventRecord < ApplicationRecord
  attr_accessor :category_name
  attr_accessor :region_name

  before_validation :find_or_create_category
  before_validation :find_or_create_region

  belongs_to :category, optional: true
  belongs_to :region, optional: true
  belongs_to :data_provider

  has_many :urls, as: :web_urlable, class_name: "WebUrl"
  has_one :organizer, as: :companyable, class_name: "OperatingCompany"
  has_many :addresses, as: :addressable
  has_one :location, as: :locateable
  has_many :contacts, as: :contactable
  has_one :accessibility_information, as: :accessable
  has_many :price_informations, as: :priceable, class_name: "Price"
  has_many :media_contents, as: :mediaable
  has_one :repeat_duration
  has_many :dates, as: :dateable, class_name: "FixedDate"

  accepts_nested_attributes_for :urls, reject_if: ->(attr) { attr[:url].blank? }
  accepts_nested_attributes_for :data_provider, :organizer,
                                :addresses, :location, :contacts,
                                :accessibility_information, :price_informations, :media_contents,
                                :repeat_duration, :dates
  acts_as_taggable

  validates_presence_of :title

  def find_or_create_category
    self.category_id = Category.where(name: category_name).first_or_create.id
  end

  def find_or_create_region
    self.region_id = Region.where(name: region_name).first_or_create.id
  end
end

# == Schema Information
#
# Table name: event_records
#
#  id               :bigint           not null, primary key
#  parent_id        :integer
#  region_id        :bigint
#  description      :text(65535)
#  repeat           :boolean
#  title            :string(255)
#  category_id      :bigint
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  data_provider_id :integer
#
