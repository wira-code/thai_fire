class Admin::CategoriesController < ApplicationController
  before_action :set_category, only: [ :destroy ]
  def index
    @categories = Category.all.order(created_at: :desc)
    @category = Category.new
  end

  def new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path, notice: "เพิ่มหมวดหมู่เรียบร้อยแล้ว!"
    else
      @categories = Category.all.order(created_at: :desc)
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    if @category.products.any?
      redirect_to admin_categories_path, alert: "ไม่สามารถลบได้ เนื่องจากมีเมนูอาหารในหมวดหมู่นี้อยู่"
    else
      @category.destroy
      redirect_to admin_categories_path, notice: "ลบหมวดหมู่เรียบร้อยแล้ว", status: :see_other
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
