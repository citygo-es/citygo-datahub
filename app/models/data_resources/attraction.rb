# frozen_string_literal: true

#
# Attraction is the superclass for all (touristic) attractions.
#
class Attraction < ApplicationRecord
  attr_accessor :category_name
  attr_accessor :category_names

  after_save :find_or_create_category

  belongs_to :data_provider

  has_and_belongs_to_many :certificates, optional: true
  has_and_belongs_to_many :regions, optional: true
  has_many :addresses, as: :addressable, dependent: :destroy
  has_one :contact, as: :contactable, dependent: :destroy
  has_many :media_contents, as: :mediaable, dependent: :destroy
  has_one :accessibility_information, as: :accessable, dependent: :destroy
  has_one :operating_company, as: :companyable, dependent: :destroy
  has_many :web_urls, as: :web_urlable, dependent: :destroy
  has_one :external_reference, as: :external, dependent: :destroy

  scope :visible, -> { where(visible: true) }

  validates_presence_of :name
  acts_as_taggable

  accepts_nested_attributes_for :web_urls, reject_if: ->(attr) { attr[:url].blank? }
  accepts_nested_attributes_for :addresses, :contact, :media_contents,
                                :accessibility_information, :operating_company,
                                :data_provider, :certificates,
                                :regions

  # Sicherstellung der Abwärtskompatibilität seit 09/2020
  def category
    ActiveSupport::Deprecation.warn(":category is replaced by has_many :categories")
    categories.first
  end

  def to_geojson
    {
      type: "Feature",
      properties: {
        name: name,
        name_de: name,
        name_en: name,
        category: categories.map(&:name).join(", "),
        icon: {
          id: "bikeRepIcon",
          svg: "<svg xmlns=\"http://www.w3.org/2000/svg\" id=\"Ebene_1\" data-name=\"Ebene 1\" viewBox=\"0 0 32.53 32.54\">  <defs>    <style>      .cls-2{fill:#fff}    </style>  </defs>  <path fill=\"#000001\" d=\"M313.29 384.05A16.27 16.27 0 11297 367.78a16.27 16.27 0 0116.26 16.27\" transform=\"translate(-280.76 -367.78)\"/>  <path d=\"M299.66 384.6a1.43 1.43 0 01-1.05-.44 1.35 1.35 0 01-.46-1 1.56 1.56 0 011.51-1.51 1.42 1.42 0 011 .45 1.51 1.51 0 01.44 1.06 1.5 1.5 0 01-1.48 1.47zm-7.87 4.89a3.55 3.55 0 012.65 1.09 3.62 3.62 0 011.07 2.67 3.66 3.66 0 01-3.72 3.72 3.65 3.65 0 01-2.67-1.07 3.55 3.55 0 01-1.09-2.65 3.72 3.72 0 013.76-3.76zm0 6.36a2.59 2.59 0 002.6-2.6 2.53 2.53 0 00-.76-1.86 2.45 2.45 0 00-1.84-.78 2.66 2.66 0 00-2.64 2.64 2.46 2.46 0 00.78 1.84 2.53 2.53 0 001.86.76zm4.32-7.49l1.65 1.73v4.63h-1.47V391l-2.43-2.11a1.18 1.18 0 01-.42-1.05 1.45 1.45 0 01.42-1.06l2.11-2.11a1.19 1.19 0 011.06-.42 1.86 1.86 0 011.19.42l1.44 1.45a3.68 3.68 0 002.67 1.12v1.51a5.18 5.18 0 01-3.79-1.58l-.6-.6zm6.15 1.13a3.72 3.72 0 013.76 3.76 3.55 3.55 0 01-1.09 2.65 3.62 3.62 0 01-2.67 1.07 3.66 3.66 0 01-3.72-3.72 3.62 3.62 0 011.07-2.67 3.55 3.55 0 012.65-1.09zm0 6.36a2.53 2.53 0 001.86-.76 2.46 2.46 0 00.78-1.84 2.66 2.66 0 00-2.64-2.64 2.46 2.46 0 00-1.84.78 2.53 2.53 0 00-.76 1.86 2.59 2.59 0 002.6 2.6zM304 374.92a.38.38 0 01.38.14.65.65 0 01.15.48v1.86a.51.51 0 01-.57.58h-7.4a3.46 3.46 0 01-1.34 1.58 3.67 3.67 0 01-2.07.61 3.79 3.79 0 01-2.22-.69 3.33 3.33 0 01-1.33-1.79h3.55v-2.44h-3.55a3.8 3.8 0 013.54-2.48 3.76 3.76 0 012.08.61 3.46 3.46 0 011.34 1.58z\" class=\"cls-2\" transform=\"translate(-280.76 -367.78)\"/></svg>"
        }
      },
      geometry: {
        type: "Point",
        coordinates: location.try(:geo_location).try(:coordinates)
      }
    }
  end

  private

    # callback function which enables setting of category by
    # virtual attribute category name.
    # ATTENTION: With this callback the setting of category is only possible with category_name.
    #            PointOfInterest.create(category: Category.first) doesn't work anymore.
    def find_or_create_category
      # für Abwärtskompatibilität, wenn nur ein einiger Kategorienamen angegeben wird
      # ist der attr_accessor :category_name befüllt
      if category_name.present?
        category_to_add = Category.where(name: category_name).first_or_create
        categories << category_to_add unless categories.include?(category_to_add)
      end

      # Wenn mehrere Kategorein auf einmal gesetzt werden
      # ist der attr_accessor :category_names befüllt
      if category_names.present?
        category_names.each do |cat|
          category_to_add = Category.where(name: cat[:name]).first_or_create
          categories << category_to_add unless categories.include?(category_to_add)
        end
      end
    end
end

# == Schema Information
#
# Table name: attractions
#
#  id                      :bigint           not null, primary key
#  name                    :string(255)
#  description             :text(65535)
#  mobile_description      :text(65535)
#  active                  :boolean          default(TRUE)
#  length_km               :integer
#  means_of_transportation :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  type                    :string(255)      default("PointOfInterest"), not null
#  data_provider_id        :integer
#  visible                 :boolean          default(TRUE)
#
