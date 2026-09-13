class PagesController < ApplicationController
  # skip_before_action :authenticate_user!, only: [:home]

  def home
    # @categories = Category.all
    @categories = Category.where(active: true).order(:position)
    # ดึงเฉพาะสินค้าแนะนำ หรือ 6 รายการแรก
    # @featured_products = Product.where(active: true).limit(6)


    # active_products = Product.where(active: true)
    # ดึงเฉพาะรายการที่ทำเครื่องหมายไว้ กลุ่มละ 3 รายการ
    # @featured_products = Product.where(active: true, featured: true).limit(3)
    # @bestseller_products = Product.where(active: true, bestseller: true).limit(3)
    #
    # ดึงเฉพาะรายการที่เป็น "เมนูแนะนำ" ( featured: true )
    @featured_products = Product.where(active: true, featured: true).limit(3)
    # ดึงเฉพาะรายการที่เป็น "เมนูขายดี" ( bestseller: true )
    @bestseller_products = Product.where(active: true, bestseller: true).limit(3)
  end

  def contact
    # action เปล่าสำหรับแสดงหน้า contact
  end
end
