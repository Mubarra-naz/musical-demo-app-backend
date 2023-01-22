class Category < ApplicationRecord
  has_many :sub_categories, foreign_key: :category_id, class_name: 'Category', dependent: :destroy
  has_many :tracks, through: :sub_categories, dependent: :nullify

  belongs_to :category, class_name: 'Category', optional: true

  accepts_nested_attributes_for :sub_categories, allow_destroy: true

  validates :name, presence: true

  scope :categories, -> { where(category_id: nil) }
  scope :sub_categories, -> { where.not(category_id: nil) }
end
