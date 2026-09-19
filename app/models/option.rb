class Option < ApplicationRecord
  has_many :option_choices, dependent: :destroy
  has_many :product_options, dependent: :destroy
  has_many :products, through: :product_options

  validates :name, presence: true, uniqueness: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # 🟢 ช่วยให้สร้าง/แก้ไข OptionChoice พร้อมกับ Option ในฟอร์มเดียวได้
  accepts_nested_attributes_for :option_choices, allow_destroy: true, reject_if: :all_blank
end
