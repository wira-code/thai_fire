class ProductsController < ApplicationController
  def index
    # ดึงหมวดหมู่ทั้งหมดที่ active
    @categories = Category.where(active: true).order(:position)

    # ดึงสินค้าทั้งหมดที่เปิดใช้งานและพร้อมจำหน่าย
    @products = Product.where(active: true, available: true).order(:position)

    # กรองตาม category ถ้ามีการคลิกเลือกหมวดหมู่
    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end
  end

  def show
    @product = Product.find(params[:id])
    @options = @product.options.order(:position)
    @add_ons = @product.add_ons.where(available: true).order(:position)
  end
end
