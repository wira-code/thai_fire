class Admin::CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  before_action :set_category, only: [ :edit, :update, :destroy ]
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

  def edit
  end

  def update
      if @category.update(category_params)
        redirect_to admin_categories_path, notice: "Category was updated!"
      else
        render :edit, status: :unprocessable_entity
      end
  end

  def destroy
    if @category.products.any?
      redirect_to admin_categories_path, alert: "Cann't delete this category because has a menu"
    else
      @category.destroy
      redirect_to admin_categories_path, notice: "Category deleted !", status: :see_other
    end
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description)
  end

  def ensure_admin!
      redirect_to root_path, alert: "ไม่มีสิทธิ์เข้าถึง" unless current_user&.admin?
  end
end
