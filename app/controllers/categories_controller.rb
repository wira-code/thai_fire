class CategoriesController < ApplicationController
  # skip_before_action :authenticate_user!, only: [ :show ]

  def show
  @category = Category.find_by(id: params[:id])
    # ถ้าหา ID ไม่เจอ ให้เด้งกลับไปหน้าแรกพร้อมแจ้งเตือน
    unless @category
      redirect_to root_path, alert: "ไม่พบหมวดหมู่อาหารที่ต้องการ"
      return
    end
  # ดึงเฉพาะสินค้าที่อยู่ในหมวดหมู่นี้เท่านั้น
  @products = @category.products.where(active: true).order(:position)
  end
end
